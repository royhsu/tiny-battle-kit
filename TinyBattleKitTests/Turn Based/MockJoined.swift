//
//  MockJoined.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockJoined

import TinyBattleKit

internal final class MockJoined: TBJoined {
    
    internal typealias Player = MockPlayer
    
    // MARK: Property
    
    internal final let player: Player
    
    // MARK: Init
    
    internal init(player: Player) { self.player = player }
    
}

// MARK: - Equatable

extension MockJoined: Equatable {
    
    public static func ==(
        lhs: MockJoined,
        rhs: MockJoined
    )
    -> Bool { return lhs === rhs }
    
}
