//
//  TurnBasedBattleTests.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleTests

import XCTest

@testable import TinyBattleKit

internal final class TurnBasedBattleTests: XCTestCase {
    
    // MARK: Chainable Turn Actions
    
    internal final func testChainableTurnActions() {
        
        let caculator = Calculator()

        let result = caculator
            .respond(
                to: AddOperatorAction(byValue: 5)
            )
            .run(
                with: CalculatorResult(value: 3)
            )

        let calculatorResult = result as? CalculatorResult

        XCTAssertEqual(
            calculatorResult?.value,
            8
        )
        
    }
    
}
