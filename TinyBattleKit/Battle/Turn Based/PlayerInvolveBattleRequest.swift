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
    
    public let involved: BattleInvolved
    
    // MARK: Init
    
    public init(involved: BattleInvolved) { self.involved = involved }
    
}
