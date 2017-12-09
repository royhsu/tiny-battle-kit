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
            
            let owner = MockBattlePlayer(id: ownerId)
            
            let playerA = MockBattlePlayer(id: playerAId)
            
            let playerB = MockBattlePlayer(id: playerBId)
            
            let today = Date()
            
            let record = MockBattleRecord(
                id: recordId,
                state: .end,
                createdAtDate: today,
                updatedAtDate: today,
                owner: owner,
                joineds: [],
                readys: [],
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
                        server.record.turns[index].involveds.map { $0.player.id },
                        record.turns[index].involveds.map { $0.player.id }
                    )
                    
                }
                
            },
            didStart: { server in

                performTest {
                    
                    XCTAssertFalse(server.record.isLocked)
                    
                    XCTAssertEqual(
                        server.record.state,
                        .start
                    )

                    XCTAssert(server.record.joineds.isEmpty)
                    
                    server.respond(
                        to: JoinedBattleRequest(
                            joined: MockBattleJoined(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.ownerId)
                            )
                        )
                    )
                    
                    server.respond(
                        to: JoinedBattleRequest(
                            joined: MockBattleJoined(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.playerAId)
                            )
                        )
                    )
                    
                    server.respond(
                        to: JoinedBattleRequest(
                            joined: MockBattleJoined(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.playerBId)
                            )
                        )
                    )

                    XCTAssert(server.record.readys.isEmpty)

                    server.respond(
                        to: ReadyBattleRequest(
                            ready: MockBattleReady(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.ownerId),
                                entities: []
                            )
                        )
                    )

                    server.respond(
                        to: ReadyBattleRequest(
                            ready: MockBattleReady(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.playerAId),
                                entities: []
                            )
                        )
                    )

                    server.respond(
                        to: ReadyBattleRequest(
                            ready: MockBattleReady(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.playerBId),
                                entities: []
                            )
                        )
                    )
                    
                }

            },
            didStartTurn: { server, turn in

                performTest {

                    XCTAssertFalse(server.record.isLocked)
                    
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
                        to: InvolvedBattleRequest(
                            involved: MockBattleInvolved(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.ownerId),
                                entities: [],
                                actions: []
                            )
                        )
                    )

                    server.respond(
                        to: InvolvedBattleRequest(
                            involved: MockBattleInvolved(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.playerAId),
                                entities: [],
                                actions: []
                            )
                        )
                    )

                    server.respond(
                        to: InvolvedBattleRequest(
                            involved: MockBattleInvolved(
                                id: UUID().uuidString,
                                player: MockBattlePlayer(id: self.playerBId),
                                entities: [],
                                actions: []
                            )
                        )
                    )
                    
                }

            },
            didEndTurn: { server, turn in

                performTest {

                    XCTAssertFalse(server.record.isLocked)
                    
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
                        server.record.readys.map { $0.player.id },
                        currenTurn.involveds.map { $0.player.id }
                    )

                }

            },
            shouldEnd: { server in return true },
            didEnd: { server in
            
                promise.fulfill()
            
                performTest {
                    
                    XCTAssertFalse(server.record.isLocked)
                    
                    XCTAssertEqual(
                        server.record.state,
                        .end
                    )
                    
                }
                
            },
            didRespondToRequest: { server, request in

                XCTAssertFalse(server.record.isLocked)
                
                if let request = request as? JoinedBattleRequest {

                    performTest {

                        let hasPlayerJoined = server
                            .record
                            .joineds
                            .contains { $0.player.id == request.joined.player.id }

                        XCTAssert(hasPlayerJoined)

                    }

                    return

                }

                if let request = request as? ReadyBattleRequest {

                    performTest {

                        let isPlayerReady = server
                            .record
                            .readys
                            .contains { $0.player.id == request.ready.player.id }
                        
                        XCTAssert(isPlayerReady)

                    }

                    let readyPlayerIds = server.record.readys.map { $0.player.id }

                    if
                        readyPlayerIds == [
                            self.ownerId,
                            self.playerAId,
                            self.playerBId
                        ] {

                        server.respond(
                            to: ContinueBattleRequest(
                                owner: MockBattlePlayer(id: self.ownerId)
                            )
                        )

                    }

                    return

                }
                
                if request is InvolvedBattleRequest { return }

                if request is ContinueBattleRequest { return }
                
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
