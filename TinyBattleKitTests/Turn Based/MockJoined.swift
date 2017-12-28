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
    
    internal final let id: MockJoinedID
    
    internal final let player: Player
    
    // MARK: Init
    
    internal init(
        id: MockJoinedID,
        player: Player
    ) {
        
        self.id = id
        
        self.player = player
        
    }
    
}

// MARK: - Equatable

extension MockJoined: Equatable {
    
    internal static func ==(
        lhs: MockJoined,
        rhs: MockJoined
    )
    -> Bool {
        
        return
            lhs.id == rhs.id
            && lhs.player === rhs.player
        
    }
    
}

// MARK: - Hashable

extension MockJoined: Hashable {
    
    internal var hashValue: Int {
        
        return
            id.hashValue
            ^ player.hashValue
        
    }
    
}
