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
    
    // MARK: Server
    
    internal final func testTurnBasedBattleServer() {
        
        let promise = expectation(description: "Start a turn-based battle server.")
        
        let server = TurnBasedBattleServer()
        
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
        
        let mockServerDataProvider = MockTurnBasedBattleServerDataProvider()
        
        XCTAssertEqual(
            mockServerDataProvider.serverState,
            .offline
        )
        
        server.serverDataProvider = mockServerDataProvider
        
        server.serverDelegate = stubServerDelegate
        
        XCTAssertEqual(
            server.state,
            .end
        )
        
        server.resume()
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
