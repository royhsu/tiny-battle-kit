//
//  PlayerInvolveBattleRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PlayerInvolveBattleRequest

public struct PlayerInvolveBattleRequest: BattleRequest {
    
    // MARK: Property
    
    public let player: InvolvedBattlePlayer
    
    // MARK: Init
    
    public init(player: InvolvedBattlePlayer) { self.player = player }
    
}
