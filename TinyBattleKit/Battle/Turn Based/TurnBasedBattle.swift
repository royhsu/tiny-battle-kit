//
//  TurnBasedBattle.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattle

open class TurnBasedBattle<Animator: BattleActionAnimator>: BattleActionResponder {
    
    public typealias Provider = AnyBattleActionProvider<Animator>
    
    // MARK: Property
    
    internal final var actionProviders: [Provider] = []
    
    // MARK: Init
    
    public init() { }
    
    // MARK: BattleActionResponder
    
    @discardableResult
    public final func respond(to provider: Provider) -> Self {

        actionProviders.append(provider)

        return self

    }
    
    // Run this method won't modify the original actionProviders.
    //  It sorts providers depends on their priority before executes each of them.
    public func run(with initalResult: Result) -> Promise<Result> {
    
        let applyingProviders = actionProviders
        
        let preservedProviders = applyingProviders.filter { !$0.shouldRemoveAfterApplyAction() }
        
        actionProviders = preservedProviders
        
        return Promise { fulfull, _, _ in
            
            let finalResult = applyingProviders
                .sorted(
                    by: { $0.priority > $1.priority }
                )
                .reduce(initalResult) { currentResult, provider in
    
                    let promise = Promise<Result>(in: .main) { fulfull, _, _ in
    
                        let newResult = provider.applyAction(on: currentResult)
                        
                        guard
                            let animator = provider.animator
                        else {
                            
                            fulfull(newResult)
                            
                            return
                            
                        }
                        
                        animator.animate(
                            from: currentResult,
                            to: newResult,
                            completion: { fulfull(newResult) }
                        )
                        
                    }
    
                    let nextResult = try! await(promise)
    
                    return nextResult
    
                }
            
            fulfull(finalResult)
            
        }

    }
    
}
