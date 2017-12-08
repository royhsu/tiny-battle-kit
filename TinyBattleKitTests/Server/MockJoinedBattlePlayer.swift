//
//  MockJoinedBattlePlayer.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockJoinedBattlePlayer

import TinyBattleKit

internal struct MockJoinedBattlePlayer: JoinedBattlePlayer {
    
    // MARK: Property
    
    internal let id: String
    
    internal let entities: [BattleEntity]
    
    internal let action: [BattleAction]
    
}
