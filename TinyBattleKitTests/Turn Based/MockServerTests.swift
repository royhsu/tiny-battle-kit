//
//  MockServerTests.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockServerTests

import XCTest

@testable import TinyBattleKit

internal final class MockServerTests: XCTestCase {
    
    // MARK: Test
    
    internal final func testServer() {
        
        let promise = expectation(description: "Test server.")

        performTest {

            let owner = MockPlayer(
                id: MockPlayerID(
                    UUID().uuidString
                )
            )
            
            let now = Date()
            
            let session = MockSession(
                state: .start,
                owner: owner,
                created: now,
                updated: now,
                joineds: [],
                readys: []
            )
            
            let server = MockServer(session: session)
            
            let listener = StubServerEventListener(
                online: { trigger in print("Online!") }
            )
            
            server.addListener(
                listener,
                action: StubServerEventListener.online,
                for: .online
            )
            
            XCTAssertEqual(
                server.session.state,
                .end
            )
            
            server.resume()
            
            XCTAssertEqual(
                server.session.state,
                .start
            )
            
            XCTAssert(server.session.joineds.isEmpty)
            
            async { _ in
                
                let joinedRequest = TBRequest(
                    player: owner,
                    data: MockJoined(player: owner)
                )
                
                let updatedBeforeJoined = session.updated
            
                let joinedResponse = try ..server.respond(to: joinedRequest)

                guard
                    let joined = joinedResponse.request.data as? MockJoined
                else { XCTFail("Expect an joined."); return }

                XCTAssert(
                    server.session.joineds.contains(joined)
                )

                let joinedLeeway = server.session.updated.timeIntervalSince(updatedBeforeJoined)

                XCTAssert(joinedLeeway > 0.0)

                let readyRequest = TBRequest(
                    player: owner,
                    data: MockReady(player: owner)
                )

                let updatedBeforeReady = session.updated
                
                let readyResponse = try ..server.respond(to: readyRequest)
                
                guard
                    let ready = readyResponse.request.data as? MockReady
                else { XCTFail("Expect a ready."); return }
                
                XCTAssert(
                    server.session.readys.contains(ready)
                )
                
                let readyLeeway = server.session.updated.timeIntervalSince(updatedBeforeReady)
                
                XCTAssert(readyLeeway > 0.0)
            
            }
            .catch(in: .main) { error in XCTFail("\(error)") }
            .always(in: .main) { promise.fulfill() }
            
        }
    
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
