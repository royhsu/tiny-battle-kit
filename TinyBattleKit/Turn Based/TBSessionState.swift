//
//  TBSessionState.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSessionState

public enum TBSessionState {
    
    // MARK: Case
    
    // The session has been closed and denies any changes. There is no way to re-activate it.
    case terminated
    
    // The session will timeout if there is no updates for a period of time. Calling resume() on server for re-activating the session.
    case timeout
    
    // The session has been created but is not ready to apply any changes.
    case idle
    
    // The session is alive to respond to changes.
    case running
    
}

// MARK: - Transition

extension TBSessionState {
    
    public static func validateTransition(
        from old: TBSessionState,
        to new: TBSessionState
    )
    -> Bool {
            
        switch (old, new) {
            
        case
            (.idle, .running),
            (.timeout, .running),
            (.running, .timeout),
            (.running, .terminated):
            
            return true
            
        default: return false
            
        }
            
    }
    
}
