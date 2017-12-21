//
//  TBSessionStateMachine.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSessionStateMachineError

internal enum TBSessionStateMachineError: Error {
 
    // MARK: Case
    
    case invalidTransition(
        from: TBSessionState,
        new: TBSessionState
    )
    
}

// MARK: - TBSessionStateMachine

internal final class TBSessionStateMachine {
    
    internal typealias State = TBSessionState
    
    // MARK: Property
    
    private final var _state: State
    
    // MARK: Init
    
    internal init(state: State) { self._state = state }
    
}

// MARK: - Transition

internal extension TBSessionStateMachine {
    
    internal final var state: State { return _state }
    
    internal final func transit(to new: State) throws {
        
        let old = _state
        
        let isValidTransition = State.validateTransition(
            from: old,
            to: new
        )
        
        guard isValidTransition else {
            
            let error: TBSessionStateMachineError = .invalidTransition(
                from: old,
                new: new
            )
            
            throw error
            
        }
        
        _state = new
        
    }
    
}
