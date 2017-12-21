//
//  TBServer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBServer

open class TBServer<Session: TBSession> {
    
    // MARK: Property
    
    public private(set) final var session: Session
    
    private final let stateMachine = TBSessionStateMachine(state: .end)
    
    // MARK: Init
    
    public init(session: Session) {
        
        self.session = session
        
        self.session.state = stateMachine.state
        
    }
    
}

// MARK: - Run

public extension TBServer {
    
    public final func resume() {
        
        do {
            
            try stateMachine.transit(to: .start)
            
            session.state = stateMachine.state
            
        }
        catch { fatalError("\(error)") }
        
    }
    
}
