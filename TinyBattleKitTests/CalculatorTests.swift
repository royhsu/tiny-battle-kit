//
//  CalculatorTests.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - CalculatorTests

import XCTest

@testable import TinyBattleKit

internal final class CalculatorTests: XCTestCase {
    
    // MARK: Chainable Turn Actions
    
    internal final func testChainableOperators() {
        
        let caculator = Calculator()

        let result = caculator
            .respond(
                to: .add(by: 5.0)
            )
            .respond(
                to: .multiply(by: 4.0)
            )
            .run(
                with: .init(value: 3.0)
            )

        XCTAssertEqual(
            result.value,
            (3.0 + 5.0) * 4.0
        )
        
    }
    
}
