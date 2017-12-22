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
    
    internal final let id: MockReadyID
    
    internal final let player: Player?
    
    // MARK: Init
    
    internal init(
        id: MockReadyID,
        player: Player
    ) {
        
        self.id = id
        
        self.player = player
        
    }
    
}

// MARK: - Equatable

extension MockReady: Equatable {
    
    public static func ==(
        lhs: MockReady,
        rhs: MockReady
    )
    -> Bool {
        
        return
            lhs.id == rhs.id
            && lhs.player === rhs.player
        
    }
    
}

// MARK: - Hashable

extension MockReady: Hashable {
    
    internal var hashValue: Int { return id.hashValue }
    
}
