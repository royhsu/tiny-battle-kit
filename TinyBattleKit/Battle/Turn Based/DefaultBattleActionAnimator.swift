//
//  DefaultBattleActionAnimator.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 03/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - DefaultBattleActionAnimator

// Use this default animator if you don't want to provide any animation for your action provider.
public struct DefaultBattleActionAnimator<Result: BattleResult>: BattleActionAnimator {
    
    public struct Context: BattleActionAnimatorContext { }
    
    // MARK: Property
    
    public let context = Context()
    
    // MARK: BattleActionAnimator
    
    public func animate(
        from oldResult: Result,
        to newResult: Result,
        completion: @escaping () -> Void
    ) { completion() }
    
}
