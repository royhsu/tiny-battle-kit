//
//  BattleTurnActionResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleTurnActionResponder

public protocol BattleTurnActionResponder: class {
    
    func respond(to turnAction: BattleTurnAction) -> BattleTurnActionResponder
    
    func run(with initialResult: BattleResult) -> BattleResult
    
}

// MARK: - TurnBasedBattle

public protocol TurnBasedBattle: class {
    
    var turnActions: [BattleTurnAction] { get set }
    
}

// MARK: - BattleTurnActionResponder (Default Implementation)

public extension TurnBasedBattle where Self: BattleTurnActionResponder {
    
    public func respond(to turnAction: BattleTurnAction) -> BattleTurnActionResponder {
        
        turnActions.append(turnAction)
        
        return self
        
    }
    
    public func run(with initalResult: BattleResult) -> BattleResult {
        
        return turnActions.reduce(initalResult) { currentResult, turnAction in
            
            return turnAction.apply(on: currentResult)
            
        }
        
    }
    
}
