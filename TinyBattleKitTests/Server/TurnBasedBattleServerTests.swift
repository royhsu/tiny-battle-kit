//
//  TurnBasedBattleServerTests.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleServerTests

import XCTest

@testable import TinyBattleKit

internal final class TurnBasedBattleServerTests: XCTestCase {

    // MARK: Property
    
    internal final var serverDataProvider: TurnBasedBattleServerDataProvider?
    
    internal final let ownerId = UUID().uuidString
    
    internal final let recordId = UUID().uuidString
    
    internal final let playerAId = UUID().uuidString
    
    internal final let playerBId = UUID().uuidString
    
    internal final var owner: BattlePlayer?
    
    internal final var record: TurnBasedBattleRecord?
    
    internal final var server: TurnBasedBattleServer?
    
    // MARK: Set Up
    
    internal final override func setUp() {
        
        super.setUp()
        
        performTest {
            
            let mockServerDataProvider = MockTurnBasedBattleServerDataProvider(
                ownerId: ownerId,
                recordId: recordId,
                playerAId: playerAId,
                playerBId: playerBId
            )
            
            XCTAssertEqual(
                mockServerDataProvider.serverState,
                .offline
            )
            
            self.serverDataProvider = mockServerDataProvider
            
            self.owner = mockServerDataProvider.fetchPlayer(id: ownerId)
            
            self.record = mockServerDataProvider.fetchRecord(id: recordId)
            
            let server = TurnBasedBattleServer(
                ownerId: ownerId,
                recordId: recordId
            )
            
            server.serverDataProvider = mockServerDataProvider
            
            self.server = server
            
        }
        
    }
    
    internal final override func tearDown() {
        
        server = nil
        
        record = nil
        
        owner = nil
        
        serverDataProvider = nil
        
        super.tearDown()
        
    }
    
    // MARK: Server
    
    internal final func testTurnBasedBattleServer() {
        
        let promise = expectation(description: "Start a turn-based battle server.")
        
        let stubServerDelegate = StubTurnBasedBattleServerDelegate(
            didStart: { server in
            
                promise.fulfill()
                
                let serverDataProvider = server.serverDataProvider as? MockTurnBasedBattleServerDataProvider
                
                XCTAssertNotNil(server.owner)
                
                XCTAssertNotNil(server.record)
                
                XCTAssertEqual(
                    serverDataProvider?.serverState,
                    .online
                )
                
                XCTAssertEqual(
                    server.state,
                    .start
                )
                
                server.respond(to:
                    JoinBattleRequest(playerId: self.playerAId)
                )
                
                server.respond(to:
                    JoinBattleRequest(playerId: self.playerBId)
                )
                
            },
            didStartTurn: { server, turn in XCTFail() },
            didEndTurn: { server, turn in XCTFail() },
            shouldEnd: { server in return false },
            didEnd: { server in XCTFail() },
            didRespondToRequest: { server, request in
                
                if let request = request as? JoinBattleRequest {

                    performTest {
                        
                        let playerId = request.playerId
                        
                        let hasPlayerJoined = server.joinedPlayers.contains { $0.id == playerId }
    
                        XCTAssert(hasPlayerJoined)
                        
                        
                    }
                    
                    return

                }
            
                XCTFail("Unknown request.")
                
            },
            didFail: { server, error in
                
                promise.fulfill()
                
                XCTFail("\(error)")
                
            }
        )
        
        performTest {
            
            let server = try unwrap(self.server)
            
            server.serverDelegate = stubServerDelegate
            
            XCTAssertEqual(
                server.state,
                .end
            )
    
            server.resume()
            
        }
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}