//
//  BattleActionProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleActionProvider

public protocol BattleActionProvider: class {
    
    associatedtype Result: BattleResult
    
    var priority: Double { get }
    
    func applyAction(on result: Result) -> Result
    
}
