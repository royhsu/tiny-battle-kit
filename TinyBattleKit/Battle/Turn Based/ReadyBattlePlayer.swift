//
//  ReadyBattlePlayer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ReadyBattlePlayer

public protocol ReadyBattlePlayer: BattlePlayer {
    
    var entities: [BattleEntity] { get }
    
    var actions: [BattleAction] { get }
    
}
