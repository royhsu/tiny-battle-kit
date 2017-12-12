//
//  BattleActionProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleActionProvider

public protocol BattleActionProvider: class {
    
    associatedtype Animator: BattleActionAnimator
    
    typealias Result = Animator.Result
    
    var id: String { get }
    
    var priority: Double { get }
    
    var animator: Animator? { get }
    
    func applyAction(on result: Result) -> Result
    
    func shouldRemoveAfterApplyAction() -> Bool
    
}
