//
//  MockPlayer.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockPlayer

import TinyBattleKit

internal final class MockPlayer: TBPlayer {
    
    // MARK: Property
    
    internal final let id: MockPlayerID
    
    // MARK: Init
    
    internal init(id: MockPlayerID) { self.id = id }
    
}

// MARK: - Equatable

extension MockPlayer: Equatable {
    
    internal static func ==(
        lhs: MockPlayer,
        rhs: MockPlayer
    )
    -> Bool { return lhs.id == rhs.id }
    
}

// MARK: - Equatable

extension MockPlayer: Hashable {

    internal var hashValue: Int { return id.hashValue }
    
}
