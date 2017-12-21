//
//  TBServerTests.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBServerTests

import XCTest

@testable import TinyBattleKit

internal final class TBServerTests: XCTestCase {
    
    // MARK: Test
    
    internal final func testServer() {
        
        let promise = expectation(description: "Test server.")

        performTest {

            let owner = MockPlayer()
            
            let session = MockSession(
                state: .start,
                owner: owner,
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
            
            let joined = MockJoined(player: owner)
            
            let request = TBRequest(
                player: owner,
                data: joined
            )
            
            server.respond(to: request)
                .then(in: .main) { response in
                    
                    let a = response.request.data as? MockJoined
                    
                    XCTAssertNotNil(a)
                    
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
