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
    
    case serverNotInState(TurnBasedBattleServerState)
    
    case battleRecordIsLocked(recordId: String)
    
    case battlePlayerNotFound(playerId: String)
    
    case battlePlayerHasJoined(playerId: String)
    
    case battlePlayerNotJoined(playerId: String)
    
    case battlePlayerIsReady(playerId: String)
    
    case battlePlayerHasInvolvedCurrentTurn(playerId: String)
    
    case unsupportedBattleRequest
    
    case onwerRequiredBattleRequest
    
}
