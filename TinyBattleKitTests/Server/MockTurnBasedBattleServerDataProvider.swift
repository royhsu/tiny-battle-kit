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
    
    internal final func updateServerState(_ state: BattleServerState) {
        
        serverState = state
        
    }
    
}
