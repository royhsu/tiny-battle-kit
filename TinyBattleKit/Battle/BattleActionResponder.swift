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
    
    typealias Result = Provider.Animator.Result
    
    func respond(to provider: Provider) -> Self
    
    func run(with initialResult: Result) -> Promise<Result>
    
}
