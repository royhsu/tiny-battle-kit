//
//  MockReadyBattlePlayer.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockReadyBattlePlayer

import TinyBattleKit

internal struct MockReadyBattlePlayer: ReadyBattlePlayer {
    
    // MARK: Property
    
    internal let id: String
    
    internal let entities: [BattleEntity]
    
    internal let action: [BattleAction]
    
}
