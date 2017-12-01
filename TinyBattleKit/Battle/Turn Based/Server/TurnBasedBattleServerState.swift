//
//  TurnBasedBattleServerState.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerState

public enum TurnBasedBattleServerState {
    
    // MARK: Case
    
    /// Server starts. (Online)
    case start
    
    /// Server starts a new / old turn.
    case turnStart
    
    /// Server ends the current turn.
    case turnEnd
    
    /// Server ends. (Offline)
    case end
    
}

