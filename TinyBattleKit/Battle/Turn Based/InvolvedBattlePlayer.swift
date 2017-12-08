//
//  InvolvedBattlePlayer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - InvolvedBattlePlayer

public protocol InvolvedBattlePlayer: BattlePlayer {
    
    var entities: [BattleEntity] { get }
    
    var actions: [BattleAction] { get }
    
}
