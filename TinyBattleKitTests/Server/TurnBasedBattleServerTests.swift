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
    
    internal final let playerAId = UUID().uuidString
    
    internal final let playerBId = UUID().uuidString
    
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
                recordId: recordId,
                playerAId: playerAId,
                playerBId: playerBId
            )
            
            self.serverDataProvider = mockServerDataProvider
            
            let owner = try unwrap(
                mockServerDataProvider.fetchPlayer(id: ownerId)
            )

            self.owner = owner
            
            let record = try unwrap(
                mockServerDataProvider.fetchRecord(id: recordId)
            )
            
            self.record = record
            
            let server = TurnBasedBattleServer(
                dataProvider: mockServerDataProvider,
                player: owner,
                record: record
            )
            
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

                performTest {
                    
                    let record = try unwrap(server.record)
                    
                    XCTAssert(!record.isLocked)

                    let now = Date()

                    let serverOnlineTimeout = now.timeIntervalSince(record.updatedAtDate)

                    XCTAssert(serverOnlineTimeout > 0.0)

                    XCTAssertEqual(
                        server.state,
                        .start
                    )

                    server.respond(to:
                        PlayerJoinBattleRequest(playerId: self.ownerId)
                    )
                    
                    server.respond(to:
                        PlayerJoinBattleRequest(playerId: self.playerAId)
                    )

                    server.respond(to:
                        PlayerJoinBattleRequest(playerId: self.playerBId)
                    )
                    
                    XCTAssert(server.readyPlayers.isEmpty)
                    
                    server.respond(
                        to: PlayerReadyBattleRequest(playerId: self.ownerId)
                    )
                    
                    server.respond(
                        to: PlayerReadyBattleRequest(playerId: self.playerAId)
                    )
                    
                    server.respond(
                        to: PlayerReadyBattleRequest(playerId: self.playerBId)
                    )

                }

            },
            didStartTurn: { server, turn in

                performTest {

                    let record = try unwrap(server.record)
                    
                    XCTAssert(!record.isLocked)
                    
                    let now = Date()
                    
                    let serverOnlineTimeout = now.timeIntervalSince(record.updatedAtDate)
                    
                    XCTAssert(serverOnlineTimeout > 0.0)
                    
                    XCTAssertEqual(
                        server.state,
                        .turnStart
                    )
                    
                    let currenTurn = try unwrap(server.record.turns.last)

                    XCTAssertEqual(
                        currenTurn.id,
                        turn.id
                    )
                    
                    server.respond(
                        to: PlayerInvolveBattleRequest(playerId: self.ownerId)
                    )
                    
                    server.respond(
                        to: PlayerInvolveBattleRequest(playerId: self.playerAId)
                    )
                    
                    server.respond(
                        to: PlayerInvolveBattleRequest(playerId: self.playerBId)
                    )
                    
                }

            },
            didEndTurn: { server, turn in

                performTest {

                    let record = try unwrap(server.record)
                    
                    XCTAssert(!record.isLocked)
                    
                    let now = Date()
                    
                    let serverOnlineTimeout = now.timeIntervalSince(record.updatedAtDate)
                    
                    XCTAssert(serverOnlineTimeout > 0.0)
                    
                    XCTAssertEqual(
                        server.state,
                        .turnEnd
                    )
                    
                    let currenTurn = try unwrap(server.record.turns.last)

                    XCTAssertEqual(
                        currenTurn.id,
                        turn.id
                    )

                    XCTAssertEqual(
                        server.readyPlayers.map { $0.id },
                        currenTurn.involvedPlayers.map { $0.id }
                    )

                }

            },
            shouldEnd: { server in return true },
            didEnd: { server in
            
                promise.fulfill()
            
                performTest {
                    
                    let record = try unwrap(server.record)
                    
                    XCTAssert(!record.isLocked)
                    
                    let now = Date()
                    
                    let serverOnlineTimeout = now.timeIntervalSince(record.updatedAtDate)
                    
                    XCTAssert(serverOnlineTimeout > 0.0)
                    
                    XCTAssertEqual(
                        server.state,
                        .end
                    )
                    
                }
                
            },
            didRespondToRequest: { server, request in

                performTest {
                    
                    let record = try unwrap(server.record)
                    
                    XCTAssert(!record.isLocked)
                    
                    let now = Date()
                    
                    let serverOnlineTimeout = now.timeIntervalSince(record.updatedAtDate)
                    
                    XCTAssert(serverOnlineTimeout > 0.0)
                    
                }
                
                if let request = request as? PlayerJoinBattleRequest {

                    performTest {

                        let playerId = request.playerId

                        let hasPlayerJoined = server.joinedPlayers.contains { $0.id == playerId }

                        XCTAssert(hasPlayerJoined)

                    }

                    return

                }
                
                if let request = request as? PlayerReadyBattleRequest {
                    
                    performTest {
                        
                        let playerId = request.playerId
                        
                        let isPlayerReady = server.readyPlayers.contains { $0.id == playerId }
                        
                        XCTAssert(isPlayerReady)
                        
                    }
                    
                    let readyPlayerIds = server.readyPlayers.map { $0.id }
                    
                    if
                        readyPlayerIds == [
                            self.ownerId,
                            self.playerAId,
                            self.playerBId
                        ] {
                        
                        server.respond(
                            to: ContinueBattleRequest(ownerId: self.ownerId)
                        )
                        
                    }
                    
                    return
                    
                }
                
                if request is ContinueBattleRequest { return }
                
                if request is PlayerInvolveBattleRequest { return }

                XCTFail("Unknown request: \(request)")

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
            
            XCTAssert(server.readyPlayers.isEmpty)

            server.resume()

        }

        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
