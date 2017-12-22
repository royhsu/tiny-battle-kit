//
//  MockPlayer.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockPlayer

import TinyBattleKit

internal final class MockPlayer: TBPlayer { }

// MARK: - Equatable

extension MockPlayer: Equatable {
    
    public static func ==(
        lhs: MockPlayer,
        rhs: MockPlayer
    )
    -> Bool { return lhs === rhs }
    
}
