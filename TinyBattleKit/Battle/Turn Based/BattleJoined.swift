//
//  BattleJoined.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleJoined

public protocol BattleJoined {
    
    var id: String { get }
    
    var player: BattlePlayer { get }
    
}
