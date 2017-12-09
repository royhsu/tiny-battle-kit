//
//  BattleInvolved.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleInvolved

public protocol BattleInvolved {
    
    var id: String { get }
    
    var player: BattlePlayer { get }
    
    var entities: [BattleEntity] { get }
    
    var actions: [BattleAction] { get }
    
}
