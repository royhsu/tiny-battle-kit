//
//  TurnBasedBattleServerError.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerError

public enum TurnBasedBattleServerError: Error {
    
    // MARK: Case
    
    case serverDataProviderNotFound
    
    case battleOwnerNotFound(ownerId: String)
    
    case battlePlayerNotFound(playerId: String)
    
    case battleRecordNotFound(recordId: String)
    
    case unsupportedBattleRequest
    
    case permissionDenied
    
}

