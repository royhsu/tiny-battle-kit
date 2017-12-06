//
//  MockTurnBasedBattleServerDataProvider.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockObservationToken

internal final class MockObservationToken: ObservationToken {
    
    internal typealias Handler = TurnBasedBattleServerDataProvider.ObserveRecordHandler
    
    // MARK: Property
    
    internal final let recordId: String
    
    internal final var handler: Handler?
    
    // MARK: Init
    
    internal init(
        recordId: String,
        handler: Handler?
    ) {
        
        self.recordId = recordId
        
        self.handler = handler
        
    }
    
    // MARK: ObservationToken
    
    internal final func invalidate() { handler = nil }
    
}

// MARK: - MockTurnBasedBattleServerDataProvider

import TinyBattleKit

internal final class MockTurnBasedBattleServerDataProvider: TurnBasedBattleServerDataProvider {
    
    // MARK: Property
    
    private final var owner: BattlePlayer?
    
    private final var record: TurnBasedBattleRecord? {
        
        didSet {
            
            guard
                let record = record,
                let token = observationToken,
                token.recordId == record.id
            else { return }
            
            token.handler?(record)
            
        }
        
    }
    
    private final var playerA: BattlePlayer?
    
    private final var playerB: BattlePlayer?
    
    private final var observationToken: MockObservationToken?
    
    // MARK: Init
    
    internal init(
        ownerId: String,
        recordId: String,
        playerAId: String,
        playerBId: String
    ) {
        
        let owner = MockBattlePlayer(id: ownerId)
        
        self.owner = owner
        
        let now = Date()
        
        self.record = MockBattleRecord(
            id: recordId,
            state: .end,
            createdAtDate: now,
            updatedAtDate: now,
            owner: owner,
            isLocked: false,
            turns: []
        )
        
        self.playerA = MockBattlePlayer(id: playerAId)
        
        self.playerB = MockBattlePlayer(id: playerBId)
        
    }
    
    // MARK: TurnBasedBattleServerDataProvider
    
    internal final func observeRecord(
        id: String,
        handler: @escaping ObserveRecordHandler
    )
    -> ObservationToken? {
        
        observationToken = MockObservationToken(
            recordId: id,
            handler: handler
        )
        
        return observationToken
        
    }
    
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
    
    func setState(
        _ state: TurnBasedBattleServerState,
        forRecord id: String
    )
    -> TurnBasedBattleRecord {
        
        var updatedRecord = record as! MockBattleRecord
        
        updatedRecord.state = state
        
        updatedRecord.updatedAtDate = Date()
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal final func appendTurnForRecord(id: String) -> TurnBasedBattleRecord {
        
        var updatedRecord = record as! MockBattleRecord
        
        updatedRecord.turns.append(
            MockBattleTurn(
                id: UUID().uuidString,
                involvedPlayers: []
            )
        )
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal final func appendInvolvedPlayer(
        _ player: BattlePlayer,
        forCurrentTurnOfRecordId recordId: String
    )
    -> TurnBasedBattleRecord {
     
        var updatedRecord = record as! MockBattleRecord
        
        var turn = updatedRecord.turns.removeLast() as! MockBattleTurn
            
        turn.involvedPlayers.append(player)
        
        updatedRecord.turns.append(turn)
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
}
