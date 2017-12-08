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
    
    public let entityIds: [String]
    
    // MARK: Init
    
    public init(
        playerId: String,
        entityIds: [String]
    ) {
        
        self.playerId = playerId
        
        self.entityIds = entityIds
        
    }
    
}
