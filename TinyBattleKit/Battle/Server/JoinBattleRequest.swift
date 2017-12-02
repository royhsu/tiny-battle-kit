//
//  JoinBattleRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - JoinBattleRequest

public struct JoinBattleRequest: BattleRequest {
    
    // MARK: Property
    
    public let playerId: String
    
    // MARK: Init
    
    public init(playerId: String) { self.playerId = playerId }
    
}
