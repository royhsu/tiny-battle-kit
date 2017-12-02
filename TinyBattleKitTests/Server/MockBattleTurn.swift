//
//  MockBattleTurn.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 02/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockBattleTurn

import TinyBattleKit

internal struct MockBattleTurn: TurnBasedBattleTurn {
    
    // MARK: Property
    
    internal let id: String
    
    internal var involvedPlayers: [BattlePlayer]
    
}
