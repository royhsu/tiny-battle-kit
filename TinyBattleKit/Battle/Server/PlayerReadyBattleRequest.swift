//
//  PlayerReadyBattleRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 05/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PlayerReadyBattleRequest

public struct PlayerReadyBattleRequest: BattleRequest {
    
    // MARK: Property
    
    public let playerId: String
    
    // MARK: Init
    
    public init(playerId: String) { self.playerId = playerId }
    
}
