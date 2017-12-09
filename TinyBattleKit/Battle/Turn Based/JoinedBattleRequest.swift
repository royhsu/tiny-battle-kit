//
//  JoinedBattleRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - JoinedBattleRequest

public struct JoinedBattleRequest: BattleRequest {
    
    // MARK: Property
    
    public let joined: BattleJoined
    
    // MARK: Init
    
    public init(joined: BattleJoined) { self.joined = joined }
    
}
