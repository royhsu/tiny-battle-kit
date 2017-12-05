//
//  TurnBasedBattleServerDataProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerDataProvider

public protocol TurnBasedBattleServerDataProvider: class {
    
    func fetchPlayer(id: String) -> BattlePlayer?
    
    func fetchRecord(id: String) -> TurnBasedBattleRecord?
    
    func setOnlineForRecord(id: String) -> TurnBasedBattleRecord
    
    // Returns: the updated record with a new turn added.
    func appendTurnForRecord(id: String) -> TurnBasedBattleRecord
    
    func appendInvolvedPlayer(
        _ player: BattlePlayer,
        forCurrentTurnOfRecordId recordId: String
    )
    -> TurnBasedBattleRecord
    
}
