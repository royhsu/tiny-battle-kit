//
//  TurnBasedBattleRecord.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

//  MARK: - TurnBasedBattleRecord

public protocol TurnBasedBattleRecord {
    
    var id: String { get }
    
    var state: TurnBasedBattleServerState { get }
    
    var createdAtDate: Date { get }
    
    /// Use this timestamp to determine whether the server is running. (Online)
    /// The data provider must update this property even if record has been read only but not modified.
    var updatedAtDate: Date { get }
    
    var owner: BattlePlayer { get }
    
    var joineds: [BattleJoined] { get }
    
    var readys: [BattleReady] { get }
    
    /// Lock a record while it shouldn't be modified anymore.
    var isLocked: Bool { get }
    
    var turns: [TurnBasedBattleTurn] { get }
    
}
