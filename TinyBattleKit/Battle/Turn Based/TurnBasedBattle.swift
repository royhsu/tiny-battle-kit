//
//  TurnBasedBattle.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattle

public protocol TurnBasedBattle: BattleActionResponder {
    
    var actionProviders: [Provider] { get set }
    
    func shouldRespond(to provider: Provider) -> Bool
    
}

// MARK: - BattleActionResponder (Default Implementation)

public extension TurnBasedBattle {
    
    public func shouldRespond(to provider: Provider) -> Bool { return true }
    
    public func respond(to provider: Provider) -> Self {
        
        actionProviders.append(provider)
        
        return self
        
    }
    
    // Run this method won't modify the original actionProviders.
    // It sorts providers depends on their priority before executes each of them.
    public func run(with initalResult: Provider.Result) -> Provider.Result {
        
        return actionProviders
            .sorted(
                by: { $0.priority > $1.priority }
            )
            .reduce(initalResult) { currentResult, provider in
            
            if shouldRespond(to: provider) {
                
                return provider.applyAction(on: currentResult)
                
            }
            
            return currentResult
            
        }
        
    }
    
}
