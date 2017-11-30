//
//  BattleActionResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleActionResponder

public protocol BattleActionResponder: class {
    
    func respond(to provider: BattleActionProvider) -> BattleActionResponder
    
    func run(with initialResult: BattleResult) -> BattleResult
    
}

// MARK: - TurnBasedBattle

public protocol TurnBasedBattle: class {
    
    var actionProviders: [BattleActionProvider] { get set }
    
}

// MARK: - BattleActionResponder (Default Implementation)

public extension TurnBasedBattle where Self: BattleActionResponder {
    
    public func respond(to provider: BattleActionProvider) -> BattleActionResponder {
        
        actionProviders.append(provider)
        
        return self
        
    }
    
    public func run(with initalResult: BattleResult) -> BattleResult {
        
        return actionProviders.reduce(initalResult) { currentResult, provider in
            
            return provider.applyAction(on: currentResult)
            
        }
        
    }
    
}
