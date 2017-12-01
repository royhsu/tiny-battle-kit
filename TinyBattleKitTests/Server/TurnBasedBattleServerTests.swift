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
    
    internal final var owner: BattlePlayer?
    
    internal final var record: TurnBasedBattleRecord?
    
    internal final var server: TurnBasedBattleServer?
    
    // MARK: Set Up
    
    internal final override func setUp() {
        
        super.setUp()
        
        performTest {
            
            let mockServerDataProvider = MockTurnBasedBattleServerDataProvider(
                ownerId: ownerId,
                recordId: recordId
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
                recordId: ownerId
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
                
                XCTAssertEqual(
                    serverDataProvider?.serverState,
                    .online
                )
                
                XCTAssertEqual(
                    server.state,
                    .start
                )
                
            },
            didStartTurn: { server, turn in XCTFail() },
            didEndTurn: { server, turn in XCTFail() },
            shouldEnd: { server in return false },
            didEnd: { server in XCTFail() },
            didRespondToRequest: { server, request in XCTFail() },
            didFail: { server, error in XCTFail()}
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
