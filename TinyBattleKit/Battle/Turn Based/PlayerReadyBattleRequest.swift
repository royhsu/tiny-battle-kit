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
    
    public let ready: BattleReady
    
    // MARK: Init
    
    public init(ready: BattleReady) { self.ready = ready }
    
}
