//
//  MockInvolvedBattlePlayer.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockInvolvedBattlePlayer

import TinyBattleKit

internal struct MockInvolvedBattlePlayer: InvolvedBattlePlayer {
    
    // MARK: Property
    
    internal let id: String
    
    internal let entities: [BattleEntity]
    
    internal let action: [BattleAction]
    
}
