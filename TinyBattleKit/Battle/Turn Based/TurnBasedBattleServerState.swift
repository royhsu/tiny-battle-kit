//
//  TurnBasedBattleServerState.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerState

public enum TurnBasedBattleServerState: String {
    
    // MARK: Case
    
    /// Server starts. (Online).
    /// Waiting for players to join.
    case start = "START"
    
    /// Server starts a new / old turn.
    case turnStart = "TURN_START"
    
    /// Server ends the current turn.
    case turnEnd = "TURN_END"
    
    /// Server ends. (Offline)
    case end = "END"
    
}

