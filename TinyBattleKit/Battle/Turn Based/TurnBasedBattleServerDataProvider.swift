//
//  TurnBasedBattleServerDataProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ObservationToken

public protocol ObservationToken {
    
    func invalidate()
    
}

// MARK: - TurnBasedBattleServerDataProvider

public protocol TurnBasedBattleServerDataProvider: class {
    
    typealias ObserveRecordHandler = (_ updatedRecord: TurnBasedBattleRecord) -> Void
    
    func observeRecord(
        id: String,
        handler: @escaping ObserveRecordHandler
    )
    -> ObservationToken?
    
    func fetchPlayer(id: String) -> BattlePlayer?
    
    func fetchRecord(id: String) -> TurnBasedBattleRecord?
    
    func setState(
        _ state: TurnBasedBattleServerState,
        forRecord id: String
    )
    -> TurnBasedBattleRecord
    
    // Returns: the updated record with a new turn added.
    func appendTurnForRecord(id: String) -> TurnBasedBattleRecord
    
    func appendInvolvedPlayer(
        _ player: BattlePlayer,
        forCurrentTurnOfRecordId recordId: String
    )
    -> TurnBasedBattleRecord
    
}
