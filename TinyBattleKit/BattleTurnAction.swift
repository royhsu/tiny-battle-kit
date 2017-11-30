//
//  BattleTurnAction.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleTurnAction

public protocol BattleTurnAction {
    
    func apply(on result: BattleResult) -> BattleResult
    
}
