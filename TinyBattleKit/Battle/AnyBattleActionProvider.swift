//
//  AnyBattleActionProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AnyBattleActionProvider

public final class AnyBattleActionProvider
<Animator: BattleActionAnimator>:
BattleActionProvider {
    
    public typealias Result = Animator.Result
    
    // MARK: Property
    
    public final let _id: String
    
    public final let _priority: Double
    
    public final let _animator: Animator?
    
    public final let _applyAction: (Result) -> Result
    
    // MARK: Init
    
    public init
    <Provider: BattleActionProvider>
    ( _ provider: Provider)
    where Provider.Animator == Animator {
        
        self._id = provider.id
        
        self._priority = provider.priority
        
        self._animator = provider.animator
        
        self._applyAction = provider.applyAction
            
    }
    
    // MARK: BattleActionProvider
    
    public final var id: String { return _id }
    
    public final var priority: Double { return _priority }

    public final var animator: Animator? { return _animator }

    public final func applyAction(on result: Result) -> Result { return _applyAction(result) }
    
}
