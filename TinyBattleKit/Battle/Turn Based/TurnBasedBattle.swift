//
//  TurnBasedBattle.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattle

open class TurnBasedBattle<Result: BattleResult>: BattleActionResponder {
    
    public typealias Provider = AnyBattleActionProvider<Result>
    
    // MARK: Property
    
    internal final var actionProviders: [Provider] = []
    
    // MARK: Init
    
    public init() { }
    
    // MARK: BattleActionResponder
    
    public func respond(to provider: Provider) -> Self {

        actionProviders.append(provider)

        return self

    }
    
    // Run this method won't modify the original actionProviders.
    //  It sorts providers depends on their priority before executes each of them.
    public func run(with initalResult: Result) -> Promise<Result> {
    
        let providers = actionProviders
        
        actionProviders.removeAll()
        
        return Promise { fulfull, _, _ in
            
            let finalResult = providers
                .sorted(
                    by: { $0.priority > $1.priority }
                )
                .reduce(initalResult) { currentResult, provider in
    
                    let promise = Promise<Result>(in: .main) { fulfull, _, _ in
    
                        let newResult = provider.applyAction(on: currentResult)
    
                        fulfull(newResult)
    
                    }
    
                    let nextResult = try! await(promise)
    
                    return nextResult
    
                }
            
            fulfull(finalResult)
            
        }

    }
    
}
