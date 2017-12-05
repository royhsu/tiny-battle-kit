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
                player: owner,
                record: record
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

                performTest {
                    
                    let record = try unwrap(server.record)
                    
                    XCTAssert(!record.isLocked)

                    let now = Date()

                    let onlineTimeInterval = now.timeIntervalSince(record.updatedAtDate)

                    XCTAssert(onlineTimeInterval > 0.0)

                    XCTAssertEqual(
                        server.state,
                        .start
                    )

                    XCTAssert(
                        server.joinedPlayers.contains { $0.id == self.ownerId }
                    )

                    server.respond(to:
                        JoinBattleRequest(playerId: self.playerAId)
                    )

                    server.respond(to:
                        JoinBattleRequest(playerId: self.playerBId)
                    )

                }

            },
            didStartTurn: { server, turn in

                performTest {

                    let currenTurn = try unwrap(server.record.turns.last)

                    XCTAssertEqual(
                        currenTurn.id,
                        turn.id
                    )
                    
                }

                server.respond(
                    to: PlayerInvolvedRequest(playerId: self.ownerId)
                )

                server.respond(
                    to: PlayerInvolvedRequest(playerId: self.playerAId)
                )

                server.respond(
                    to: PlayerInvolvedRequest(playerId: self.playerBId)
                )

            },
            didEndTurn: { server, turn in

                performTest {

                    let currenTurn = try unwrap(server.record.turns.last)

                    XCTAssertEqual(
                        currenTurn.id,
                        turn.id
                    )

                    XCTAssertEqual(
                        server.joinedPlayers.map { $0.id },
                        currenTurn.involvedPlayers.map { $0.id }
                    )

                }

            },
            shouldEnd: { server in return true },
            didEnd: { server in
            
                promise.fulfill()
                
                XCTAssertEqual(
                    server.state,
                    .end
                )
                
            },
            didRespondToRequest: { server, request in

                if let request = request as? JoinBattleRequest {

                    performTest {

                        let playerId = request.playerId

                        let hasPlayerJoined = server.joinedPlayers.contains { $0.id == playerId }

                        XCTAssert(hasPlayerJoined)

                    }

                    let joinedPlayerIds = server.joinedPlayers.map { $0.id }

                    if
                        joinedPlayerIds == [
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
                
                if request is PlayerInvolvedRequest { return }

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

            server.resume()

        }

        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
