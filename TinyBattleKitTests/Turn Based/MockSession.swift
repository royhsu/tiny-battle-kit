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
    
    internal final let created: Date
    
    internal final var updated: Date
    
    internal final let owner: Player
    
    internal final var joineds: Set<Joined>
    
    internal final var readys: Set<Ready>
    
    // MARK: Init
    
    internal init(
        state: TBSessionState,
        owner: Player,
        created: Date,
        updated: Date,
        joineds: Set<Joined>,
        readys: Set<Ready>
    ) {
        
        self.state = state
        
        self.owner = owner
        
        self.created = created
        
        self.updated = updated
        
        self.joineds = joineds
        
        self.readys = readys
        
    }
    
    // MARK: Save
    
    internal final func save() -> Promise<MockSession> {
        
        return Promise { fulfill, reject, _ in
            
            fulfill(self)
            
        }
        
    }
    
}
