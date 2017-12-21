//
//  MockReady.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockReady

import TinyBattleKit

internal final class MockReady: TBReady {
    
    internal typealias Player = MockPlayer
    
    // MARK: Property
    
    internal final let player: Player
    
    // MARK: Init
    
    internal init(player: Player) { self.player = player }
    
}
