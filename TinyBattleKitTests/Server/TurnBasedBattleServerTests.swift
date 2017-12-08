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
    
    internal final var record: TurnBasedBattleRecord?
    
    internal final var server: TurnBasedBattleServer?
    
    // MARK: Set Up
    
    internal final override func setUp() {
        
        super.setUp()
        
        performTest {
            
            let owner = MockBattlePlayer(
                id: ownerId,
                entities: []
            )
            
            let playerA = MockBattlePlayer(
                id: playerAId,
                entities: []
            )
            
            let playerB = MockBattlePlayer(
                id: playerBId,
                entities: []
            )
            
            let record = MockBattleRecord(
                id: recordId,
                state: .end,
                createdAtDate: Date(),
                updatedAtDate: Date(),
                owner: owner,
                joinedPlayers: [],
                readyPlayers: [],
                isLocked: false,
                turns: []
            )
            
            let mockServerDataProvider = MockTurnBasedBattleServerDataProvider(
                record: record,
                players: [ owner, playerA, playerB ]
            )
            
            self.serverDataProvider = mockServerDataProvider
    
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
        
        serverDataProvider = nil
        
        super.tearDown()
        
    }
    
    // MARK: Server
    
    internal final func testTurnBasedBattleServer() {
        
        let promise = expectation(description: "Start a turn-based battle server.")

        let stubServerDelegate = StubTurnBasedBattleServerDelegate(
            didUpdateRecord: { server, record in
                
                XCTAssertEqual(
                    server.record.id,
                    record.id
                )
                
                XCTAssertEqual(
                    server.record.createdAtDate,
                    record.createdAtDate
                )
                
                XCTAssertEqual(
                    server.record.updatedAtDate,
                    record.updatedAtDate
                )
                
                XCTAssertEqual(
                    server.record.owner.id,
                    record.owner.id
                )
                
                XCTAssertEqual(
                    server.record.isLocked,
                    record.isLocked
                )
                
                XCTAssertEqual(
                    server.record.turns.count,
                    record.turns.count
                )
                
                for index in 0..<server.record.turns.count {
                    
                    XCTAssertEqual(
                        server.record.turns[index].id,
                        record.turns[index].id
                    )
                    
                    XCTAssertEqual(
                        server.record.turns[index].involvedPlayers.map { $0.id },
                        record.turns[index].involvedPlayers.map { $0.id }
                    )
                    
                }
                
            },
            didStart: { server in

                performTest {
                    
                    XCTAssertFalse(server.record.isLocked)
                    
                    XCTAssert(server.isOnline)

                    XCTAssertEqual(
                        server.record.state,
                        .start
                    )

                    XCTAssert(server.record.joinedPlayers.isEmpty)
                    
                    server.respond(to:
                        PlayerJoinBattleRequest(
                            player: self.ownerId
                        )
                    )
                    
                    server.respond(to:
                        BattlePlayerJoinRequest(playerId: self.playerAId)
                    )

                    server.respond(to:
                        BattlePlayerJoinRequest(playerId: self.playerBId)
                    )
                    
                    XCTAssert(server.record.readyPlayers.isEmpty)
                    
                    server.respond(
                        to: PlayerReadyBattleRequest(
                            playerId: self.ownerId,
                            entityIds: []
                        )
                    )
                    
                    server.respond(
                        to: PlayerReadyBattleRequest(
                            playerId: self.playerAId,
                            entityIds: []
                        )
                    )
                    
                    server.respond(
                        to: PlayerReadyBattleRequest(
                            playerId: self.playerBId,
                            entityIds: []
                        )
                    )

                }

            },
            didStartTurn: { server, turn in

                performTest {

                    XCTAssertFalse(server.record.isLocked)
                    
                    XCTAssert(server.isOnline)
                    
                    XCTAssertEqual(
                        server.record.state,
                        .turnStart
                    )
                    
                    let currenTurn = try unwrap(server.record.turns.last)

                    XCTAssertEqual(
                        currenTurn.id,
                        turn.id
                    )
                    
                    server.respond(
                        to: BattlePlayerInvolveRequest(playerId: self.ownerId)
                    )

                    server.respond(
                        to: BattlePlayerInvolveRequest(playerId: self.playerAId)
                    )

                    server.respond(
                        to: BattlePlayerInvolveRequest(playerId: self.playerBId)
                    )
                    
                }

            },
            didEndTurn: { server, turn in

                performTest {

                    XCTAssertFalse(server.record.isLocked)
                    
                    XCTAssert(server.isOnline)
                    
                    XCTAssertEqual(
                        server.record.state,
                        .turnEnd
                    )
                    
                    let currenTurn = try unwrap(server.record.turns.last)

                    XCTAssertEqual(
                        currenTurn.id,
                        turn.id
                    )

                    XCTAssertEqual(
                        server.record.readyPlayers.map { $0.id },
                        currenTurn.involvedPlayers.map { $0.id }
                    )

                }

            },
            shouldEnd: { server in return true },
            didEnd: { server in
            
                promise.fulfill()
            
                performTest {
                    
                    XCTAssertFalse(server.record.isLocked)
                    
                    XCTAssert(server.isOnline)
                    
                    XCTAssertEqual(
                        server.record.state,
                        .end
                    )
                    
                }
                
            },
            didRespondToRequest: { server, request in

                performTest {
                    
                    XCTAssertFalse(server.record.isLocked)
                    
                    XCTAssert(server.isOnline)
                    
                }
                
                if let request = request as? BattlePlayerJoinRequest {

                    performTest {

                        let playerId = request.playerId

                        let hasPlayerJoined = server.record.joinedPlayers.contains { $0.id == playerId }

                        XCTAssert(hasPlayerJoined)

                    }

                    return

                }
                
                if let request = request as? PlayerReadyBattleRequest {
                    
                    performTest {
                        
                        let readyPlayers = server.record
                            .readyPlayers
                        
                        let playerId = request.playerId
                        
                        guard
                            let playerIndex = readyPlayers.index(
                                where: { $0.id == playerId }
                            )
                        else {
                            
                            XCTFail("Ready player not found.")
                            
                            return
                            
                        }
                        
                        let readyPlayer = readyPlayers[playerIndex]
                        
                        XCTAssertEqual(
                            request.entityIds,
                            readyPlayer.entities.map { $0.id }
                        )
                        
                    }
                    
                    let readyPlayerIds = server.record.readyPlayers.map { $0.id }
                    
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
                
                if request is BattlePlayerInvolveRequest { return }

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
                server.record.state,
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
