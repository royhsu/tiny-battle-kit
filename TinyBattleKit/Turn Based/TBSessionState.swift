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
    
    case start, end
    
}

// MARK: - Transition

extension TBSessionState {
    
    public static func validateTransition(
        from old: TBSessionState,
        to new: TBSessionState
    )
    -> Bool {
            
        switch (old, new) {
            
        case (.end, .start): return true
            
        default: return false
            
        }
            
    }
    
}
