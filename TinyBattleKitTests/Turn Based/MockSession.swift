//
//  MockSession.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockSession

import TinyBattleKit

internal final class MockSession: TBSession {
    
    internal typealias Joined = MockJoined
    
    // MARK: Property
    
    internal final var joineds: [Joined]
    
    // MARK: Init
    
    internal init(
        joineds: [Joined]
    ) {
        
        self.joineds = joineds
        
    }
    
}
