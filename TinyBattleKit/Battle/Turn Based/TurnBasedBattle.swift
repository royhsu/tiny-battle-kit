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
    
    public func respond(to provider: Provider) -> Self {
        
        actionProviders.append(provider)
        
        return self
        
    }
    
    public func run(with initalResult: Provider.Result) -> Provider.Result {
        
        return actionProviders.reduce(initalResult) { currentResult, provider in
            
            if shouldRespond(to: provider) {
                
                return provider.applyAction(on: currentResult)
                
            }
            
            return currentResult
            
        }
        
    }
    
}
