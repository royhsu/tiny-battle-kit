//
//  MockBattleJoined.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockBattleJoin

import TinyBattleKit

internal struct MockBattleJoined: BattleJoined {
    
    // MARK: Property
    
    internal let id: String
    
    internal let player: BattlePlayer
    
}
