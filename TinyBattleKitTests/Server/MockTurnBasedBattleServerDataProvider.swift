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
    
    internal final var serverState: BattleServerState = .offline
    
    private final var owner: BattlePlayer?
    
    private final var record: TurnBasedBattleRecord?
    
    // MARK: Init
    
    internal init(
        ownerId: String,
        recordId: String
    ) {
        
        self.owner = MockBattlePlayer(id: ownerId)
        
        self.record = MockBattleRecord(id: recordId)
        
    }
    
    // MARK: TurnBasedBattleServerDataProvider
    
    internal final func fetchPlayer(id: String) -> BattlePlayer? {
        
        if owner?.id == id { return owner }
        
        return nil
        
    }
    
    internal final func fetchRecord(id: String) -> TurnBasedBattleRecord? {
        
        if record?.id == id { return record }
        
        return nil
        
    }
    
    internal final func updateServerState(_ state: BattleServerState) {
        
        serverState = state
        
    }
    
}
