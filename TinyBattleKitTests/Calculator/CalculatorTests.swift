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
    
    // MARK: Chainable Operators
    
    internal final func testChainableOperators() {
        
        let promise = expectation(description: "Calculator runs chainable operators.")
        
        let caculator = Calculator()
        
        caculator
            .respond(
                to: .add(by: 5.0)
            )
            .respond(
                to: .multiply(by: 4.0)
            )
            .run(
                with: .init(value: 3.0)
            )
            .then { result in

                promise.fulfill()

                XCTAssertEqual(
                    result.value,
                    (3.0 * 4.0) + 5.0
                )
                
            }
            .catch { error in

                promise.fulfill()

                XCTFail("\(error)")

            }

        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
