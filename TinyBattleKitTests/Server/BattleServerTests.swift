//
//  BattleServerTests.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleServerTests

import XCTest

@testable import TinyBattleKit

internal final class BattleServerTests: XCTestCase {
    
    // MARK: Server
    
    internal final func test() {
        
        let server = TurnBasedBattleServer()
        
        XCTAssertEqual(
            server.state,
            .end
        )
        
        server.serverDelegate = StubTurnBasedBattleServerDelegate(
            didStart: { server in XCTFail() },
            didStartTurn: { server, turn in XCTFail() },
            didEndTurn: { server, turn in XCTFail() },
            shouldEnd: { server in return false },
            didEnd: { server in XCTFail() },
            didRespondToRequest: { server, request in XCTFail() },
            didFail: { server, error in XCTFail()}
        )
        
    }
    
}
