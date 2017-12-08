//
//  MockBattleRecord.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockBattleRecord

import TinyBattleKit

internal struct MockBattleRecord: TurnBasedBattleRecord {

    // MARK: Property
    
    internal let id: String
    
    internal var state: TurnBasedBattleServerState
    
    internal let createdAtDate: Date
    
    internal var updatedAtDate: Date
    
    internal var owner: BattlePlayer
    
    internal var joinedPlayers: [JoinedBattlePlayer]
    
    internal var readyPlayers: [BattlePlayer]
    
    internal var isLocked: Bool
    
    internal var turns: [TurnBasedBattleTurn]
    
    // MARK: Init
    
    internal init(
        id: String,
        state: TurnBasedBattleServerState,
        createdAtDate: Date,
        updatedAtDate: Date,
        owner: BattlePlayer,
        joinedPlayers: [JoinedBattlePlayer],
        readyPlayers: [BattlePlayer],
        isLocked: Bool,
        turns: [TurnBasedBattleTurn]
    ) {
        
        self.id = id
        
        self.state = state
        
        self.createdAtDate = createdAtDate
        
        self.updatedAtDate = updatedAtDate
        
        self.owner = owner
        
        self.joinedPlayers = joinedPlayers
        
        self.readyPlayers = readyPlayers
        
        self.isLocked = isLocked
        
        self.turns = turns
        
    }
    
}
