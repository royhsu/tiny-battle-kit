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
                else { XCTFail("Unexpected request data."); return }
                
                XCTAssert(
                    server.session.joineds.contains(joined)
                )
                
                let leeway = server.session.updated.timeIntervalSince(updatedBeforeJoined)
                
                XCTAssert(leeway > 0.0)
                
                promise.fulfill()
            
            }
            .catch(in: .main) { error in XCTFail("\(error)") }
            
        }
    
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
