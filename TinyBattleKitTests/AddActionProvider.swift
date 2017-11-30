//
//  AddActionProvider.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AddActionProvider

import TinyBattleKit

internal struct AddActionProvider: BattleActionProvider {
    
    // MARK: Property
    
    internal let value: Double
    
    // MARK: BattleActionProvider
    
    internal func applyAction(on result: BattleResult) -> BattleResult {
        
        guard
            let result = result as? CalculatorResult
        else { fatalError() }
        
        return CalculatorResult(
            value: result.value + value
        )
        
    }
    
}
