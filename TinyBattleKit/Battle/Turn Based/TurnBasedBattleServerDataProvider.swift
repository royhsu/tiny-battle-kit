//
//  TurnBasedBattleServerDataProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerDataProvider

public protocol TurnBasedBattleServerDataProvider: class {
    
    func updateServerState(_ state: BattleServerState)
    
}
