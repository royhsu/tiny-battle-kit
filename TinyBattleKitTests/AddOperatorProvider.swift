//
//  AddOperatorProvider.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AddOperatorProvider

import TinyBattleKit

internal final class AddOperatorProvider: BattleActionProvider {
    
    internal typealias Result = CalculatorResult
    
    // MARK: Property
    
    internal final let value: Double
    
    // MARK: Init
    
    internal init(value: Double) { self.value = value }
    
    // MARK: BattleActionProvider
    
    internal final func applyAction(on result: Result) -> Result {
        
        return Result(
            value: result.value + value
        )
        
    }
    
}
