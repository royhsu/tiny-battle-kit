//
//  AddOperatorAction.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AddOperatorAction

import TinyBattleKit

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
