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
    
    case serverNotInState(TurnBasedBattleServerState)
    
    case serverTimeout
    
    case battleRecordIsLocked(recordId: String)
    
    case battlePlayerHasJoined(playerId: String)
    
    case battlePlayerIsReady(playerId: String)
    
    case battlePlayerHasInvolved(playerId: String)
    
    case invalidBattleRequest
    
    case unsupportedBattleRequest
    
    case onwerRequiredBattleRequest
    
}
