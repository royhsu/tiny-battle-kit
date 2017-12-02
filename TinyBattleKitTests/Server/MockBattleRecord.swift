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
    
    internal var turns: [TurnBasedBattleTurn]
    
}
