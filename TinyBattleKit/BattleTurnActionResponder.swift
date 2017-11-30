//
//  BattleTurnActionResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 30/11/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleTurnActionResponder

public protocol BattleTurnActionResponder {
    
    func respond(to turnAction: BattleTurnAction) -> BattleTurnActionResponder
    
    func run() -> BattleResult
    
}

// MARK: - TurnBasedBattle
