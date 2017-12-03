//
//  BattleActionAnimator.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 03/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleActionAnimator

public protocol BattleActionAnimator {
    
    associatedtype Context: BattleActionAnimatorContext
    
    associatedtype Result: BattleResult
    
    var context: Context { get }
    
    func animate(
        from oldResult: Result,
        to newResult: Result,
        completion: @escaping () -> Void
    )
    
}
