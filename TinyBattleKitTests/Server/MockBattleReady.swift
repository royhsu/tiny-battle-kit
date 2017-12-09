//
//  MockBattleReady.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockBattleReady

import TinyBattleKit

internal struct MockBattleReady: BattleReady {

    // MARK: Property
    
    internal let id: String
    
    internal let player: BattlePlayer
    
    internal let entities: [BattleEntity]
    
}
