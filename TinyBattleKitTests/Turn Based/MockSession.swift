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
    
    internal final var state: TBSessionState
    
    internal final var joineds: [Joined]
    
    // MARK: Init
    
    internal init(
        state: TBSessionState,
        joineds: [Joined]
    ) {
        
        self.state = state
        
        self.joineds = joineds
        
    }
    
}
