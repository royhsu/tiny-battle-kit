//
//  JoinedBattlePlayer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - JoinedBattlePlayer

public protocol JoinedBattlePlayer: BattlePlayer {
    
    var entities: [BattleEntity] { get }
    
    var action: [BattleAction] { get }
    
}
