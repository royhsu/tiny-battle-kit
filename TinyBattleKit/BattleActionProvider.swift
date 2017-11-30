//
//  BattleActionProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleActionProvider

public protocol BattleActionProvider {
    
    func applyAction(on result: BattleResult) -> BattleResult
    
}
