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
    
    internal typealias Player = MockPlayer
    
    internal typealias Joined = MockJoined
    
    internal typealias Ready = MockReady
    
    // MARK: Property
    
    internal final var state: TBSessionState
    
    internal final let owner: Player
    
    internal final var joineds: [Joined]
    
    internal final var readys: [Ready]
    
    // MARK: Init
    
    internal init(
        state: TBSessionState,
        owner: Player,
        joineds: [Joined],
        readys: [Ready]
    ) {
        
        self.state = state
        
        self.owner = owner
        
        self.joineds = joineds
        
        self.readys = readys
        
    }
    
}
