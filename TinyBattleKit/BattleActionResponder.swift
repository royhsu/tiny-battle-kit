//
//  BattleActionResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleActionResponder

public protocol BattleActionResponder: class {
    
    associatedtype Provider: BattleActionProvider
    
    func respond(to provider: Provider) -> Self
    
    func run(with initialResult: Provider.Result) -> Provider.Result
    
}

// MARK: - TurnBasedBattle

public protocol TurnBasedBattle: BattleActionResponder {
    
    var actionProviders: [Provider] { get set }
    
}

// MARK: - BattleActionResponder (Default Implementation)

public extension TurnBasedBattle {
    
    public func respond(to provider: Provider) -> Self {

        actionProviders.append(provider)

        return self

    }

    public func run(with initalResult: Provider.Result) -> Provider.Result {

        return actionProviders.reduce(initalResult) { currentResult, provider in

            return provider.applyAction(on: currentResult)

        }

    }
    
}
