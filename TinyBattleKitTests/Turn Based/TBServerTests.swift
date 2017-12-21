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
        
        let session = MockSession(
            joineds: []
        )
        
        let server = TBServer(session: session)
        
    }
    
}
