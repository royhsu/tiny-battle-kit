//
//  MockTurnBasedBattleServerDataProvider.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockTurnBasedBattleServerDataProvider

import TinyBattleKit

internal final class MockTurnBasedBattleServerDataProvider: TurnBasedBattleServerDataProvider {
    
    // MARK: Property
    
    private final var owner: BattlePlayer?
    
    private final var record: TurnBasedBattleRecord?
    
    private final var playerA: BattlePlayer?
    
    private final var playerB: BattlePlayer?
    
    // MARK: Init
    
    internal init(
        ownerId: String,
        recordId: String,
        playerAId: String,
        playerBId: String
    ) {
        
        self.owner = MockBattlePlayer(id: ownerId)
        
        let now = Date()
        
        self.record = MockBattleRecord(
            id: recordId,
            turns: [],
            createdAtDate: now,
            updatedAtDate: now
        )
        
        self.playerA = MockBattlePlayer(id: playerAId)
        
        self.playerB = MockBattlePlayer(id: playerBId)
        
    }
    
    // MARK: TurnBasedBattleServerDataProvider
    
    internal final func fetchPlayer(id: String) -> BattlePlayer? {
        
        if owner?.id == id { return owner }
        
        if playerA?.id == id { return playerA }
        
        if playerB?.id == id { return playerB }
        
        return nil
        
    }
    
    internal final func fetchRecord(id: String) -> TurnBasedBattleRecord? {
        
        if record?.id == id { return record }
        
        return nil
        
    }
    
    func addNewTurnForRecord(id: String) -> TurnBasedBattleRecord {
        
        var updatedRecord = self.record as! MockBattleRecord
        
        updatedRecord.turns.append(
            MockBattleTurn(
                id: UUID().uuidString,
                involvedPlayers: []
            )
        )
        
        self.record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal func addInvolvedPlayer(
        _ player: BattlePlayer,
        forCurrentTurnOfRecordId recordId: String
    )
    -> TurnBasedBattleRecord {
     
        var updatedRecord = self.record as! MockBattleRecord
        
        var turn = updatedRecord.turns.removeLast() as! MockBattleTurn
            
        turn.involvedPlayers.append(player)
        
        updatedRecord.turns.append(turn)
        
        self.record = updatedRecord
        
        return updatedRecord
        
    }
    
}
