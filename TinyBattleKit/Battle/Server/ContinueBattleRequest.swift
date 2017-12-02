//
//  ContinueBattleRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ContinueBattleRequest

public struct ContinueBattleRequest: BattleRequest {
    
    // MARK: Property
    
    // Todo:
    // 1. Find a better way to secure server once other players send this kind of requests should block them. Only onwer of the server can send this request.
    public let ownerId: String
    
}
