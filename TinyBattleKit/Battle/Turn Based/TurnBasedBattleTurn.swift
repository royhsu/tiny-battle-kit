//
//  TurnBasedBattleTurn.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

//  MARK: - TurnBasedBattleTurn

public protocol TurnBasedBattleTurn {
    
    var id: String { get }
    
    var involvedPlayers: [BattlePlayer] { get }
    
}
