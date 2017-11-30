//
//  TurnBasedBattleTests.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - CalculatorResult

internal struct CalculatorResult: BattleResult {
    
    // MARK: Property
    
    internal let value: Double
    
}

// MARK: - AddOperatorAction

internal struct AddOperatorAction: BattleTurnAction {
    
    // MARK: Property
    
    internal let byValue: Double
    
    // MARK: BattleTurnAction
    
    internal func apply(on result: BattleResult) -> BattleResult {
        
        guard
            let result = result as? CalculatorResult
        else { fatalError() }
        
        return CalculatorResult(
            value: result.value + byValue
        )
        
    }
    
}

// MARK: - Calculator

internal final class Calculator {
    
    // MARK: Property
    
    private final var turnActions: [BattleTurnAction] = []
    
    internal final let initalResult: CalculatorResult
    
    // MARK: Init
    
    internal init(initalResult: CalculatorResult) {
        
        self.initalResult = initalResult
        
    }
    
}

// MARK: BattleTurnActionResponder

extension Calculator: BattleTurnActionResponder {

    internal final func respond(to turnAction: BattleTurnAction) -> BattleTurnActionResponder {
        
        turnActions.append(turnAction)
        
        return self
        
    }
    
    internal final func run() -> BattleResult {

        return turnActions.reduce(initalResult) { currentResult, turnAction in

            return turnAction.apply(on: currentResult)

        }

    }

}

// MARK: - TurnBasedBattleTests

import XCTest

@testable import TinyBattleKit

internal final class TurnBasedBattleTests: XCTestCase {
    
    internal final func testChainableActionResponders() {
        
        let caculator: BattleTurnActionResponder = Calculator(
            initalResult: CalculatorResult(value: 3)
        )
        
        let result = caculator
            .respond(
                to: AddOperatorAction(byValue: 5)
            )
            .run()
        
        let calculatorResult = result as? CalculatorResult
        
        XCTAssertEqual(
            calculatorResult?.value,
            8
        )
        
    }
    
}
