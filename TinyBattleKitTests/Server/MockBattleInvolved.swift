//
//  MockBattleInvolved.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockBattleInvolved

import TinyBattleKit

internal struct MockBattleInvolved: BattleInvolved {
    
    // MARK: Property
    
    internal let id: String
    
    internal let player: BattlePlayer
    
    internal let entities: [BattleEntity]
    
    internal let actions: [BattleAction]
    
}
