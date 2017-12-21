//
//  MockRequest.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockRequest

import TinyBattleKit

internal struct MockRequest: TBRequest {
    
    internal typealias Player = MockPlayer
    
    // MARK: Property
    
    internal let player: Player
    
    // MARK: Init
    
    internal init(player: Player) { self.player = player }
    
}

