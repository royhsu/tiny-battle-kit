//
//  PlayerJoinBattleRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PlayerJoinBattleRequest

public struct PlayerJoinBattleRequest: BattleRequest {
    
    // MARK: Property
    
    public let player: JoinedBattlePlayer
    
    // MARK: Init
    
    public init(player: JoinedBattlePlayer) { self.player = player }
    
}
