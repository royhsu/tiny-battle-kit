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
    
    private final var players: [BattlePlayer]
    
    private final var observationToken: MockObservationToken?
    
    // MARK: Init
    
    internal init(
        record: TurnBasedBattleRecord,
        players: [BattlePlayer]
    ) {

        self.record = record
        
        self.players = players
        
    }
    
    // MARK: TurnBasedBattleServerDataProvider
    
    internal final func observeRecord(
        id: String,
        handler: @escaping ObserveRecordHandler
    )
    -> ObservationToken? {
        
        if id != record?.id { fatalError() }
        
        observationToken = MockObservationToken(
            recordId: id,
            handler: handler
        )
        
        return observationToken
        
    }
    
    internal final func fetchPlayer(id: String) -> BattlePlayer? {
        
        return players.filter { $0.id == id }.first
        
    }
    
    internal final func fetchRecord(id: String) -> TurnBasedBattleRecord? {
        
        if record?.id == id { return record }
        
        return nil
        
    }
    
    internal final func setState(
        _ state: TurnBasedBattleServerState,
        forRecordId id: String
    )
    -> TurnBasedBattleRecord {
        
        if id != record?.id { fatalError() }
        
        var updatedRecord = record as! MockBattleRecord
        
        updatedRecord.state = state
        
        updatedRecord.updatedAtDate = Date()
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal final func resetJoinedAndReadyPlayersForRecord(id: String) -> TurnBasedBattleRecord {
        
        if id != record?.id { fatalError() }
        
        var updatedRecord = record as! MockBattleRecord
        
        updatedRecord.joinedPlayers = []
        
        updatedRecord.readyPlayers = []
        
        updatedRecord.updatedAtDate = Date()
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal final func appendTurnForRecord(id: String) -> TurnBasedBattleRecord {
        
        if id != record?.id { fatalError() }
        
        var updatedRecord = record as! MockBattleRecord
        
        updatedRecord.turns.append(
            MockBattleTurn(
                id: UUID().uuidString,
                involvedPlayers: []
            )
        )
        
        updatedRecord.updatedAtDate = Date()
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal final func appendJoinedPlayer(
        _ player: JoinedBattlePlayer,
        forRecordId id: String
    )
    -> TurnBasedBattleRecord {
        
        if id != record?.id { fatalError() }
        
        var updatedRecord = record as! MockBattleRecord
        
        updatedRecord.joinedPlayers.append(player)
        
        updatedRecord.updatedAtDate = Date()
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal final func appendReadyPlayer(
        _ player: ReadyBattlePlayer,
        forRecordId id: String
    )
    -> TurnBasedBattleRecord {
        
        if id != record?.id { fatalError() }
        
        var updatedRecord = record as! MockBattleRecord
        
        updatedRecord.readyPlayers.append(player)
        
        updatedRecord.updatedAtDate = Date()
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
    internal final func appendInvolvedPlayer(
        _ player: InvolvedBattlePlayer,
        forCurrentTurnOfRecordId recordId: String
    )
    -> TurnBasedBattleRecord {
     
        if recordId != record?.id { fatalError() }
        
        var updatedRecord = record as! MockBattleRecord
        
        var turn = updatedRecord.turns.removeLast() as! MockBattleTurn
            
        turn.involvedPlayers.append(player)
        
        updatedRecord.turns.append(turn)
        
        updatedRecord.updatedAtDate = Date()
        
        record = updatedRecord
        
        return updatedRecord
        
    }
    
}
