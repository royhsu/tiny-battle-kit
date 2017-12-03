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
    
    internal typealias Animator = CalculatorAnimator
    
    internal typealias Result = Animator.Result
    
    // MARK: Property
    
    internal final let priority = 100.0
    
    internal final let animator: Animator? = nil
    
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

// MARK: Factory

internal extension BattleActionProvider
where Self.Animator == CalculatorAnimator {
    
    internal static func add(by value: Double) -> AnyBattleActionProvider<Animator> {
        
        let provider = AddOperatorProvider(value: value)
        
        return AnyBattleActionProvider(provider)
        
    }
    
}
