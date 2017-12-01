//
//  TurnBasedBattleServerStateMachine.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerStateMachineDelegate

public protocol TurnBasedBattleServerStateMachineDelegate: class {
    
    func machine(
        _ machine: TurnBasedBattleServerStateMachine,
        didTransitionFrom from: TurnBasedBattleServerState,
        to: TurnBasedBattleServerState
    )
    
    func machine(
        _ machine: TurnBasedBattleServerStateMachine,
        didFailWith error: Error
    )
    
}

// MARK: - TurnBasedBattleServerStateMachineError

public enum TurnBasedBattleServerStateMachineError: Error {
    
    // MARK: Case
    
    case invalidTransition(
        from: TurnBasedBattleServerState,
        to: TurnBasedBattleServerState
    )
    
}

// MARK: - TurnBasedBattleServerStateMachine

public final class TurnBasedBattleServerStateMachine {
    
    // MARK: Property
    
    private final var _state: TurnBasedBattleServerState {
        
        didSet {
            
            let newValue = _state
            
            machineDelegate?.machine(
                self,
                didTransitionFrom: oldValue,
                to: newValue
            )
            
        }
        
    }
    
    public final var state: TurnBasedBattleServerState {
        
        get { return _state }
        
        set {
            
            let oldValue = _state
            
            guard
                shouldTransition(
                    from: oldValue,
                    to: newValue
                )
            else {
                
                let error: TurnBasedBattleServerStateMachineError = .invalidTransition(
                    from: oldValue,
                    to: newValue
                )
                
                machineDelegate?.machine(
                    self,
                    didFailWith: error
                )
                
                return
                    
            }
            
            _state = newValue
            
        }
        
    }
    
    public final weak var machineDelegate: TurnBasedBattleServerStateMachineDelegate?
    
    // MARK: Init
    
    public init(state: TurnBasedBattleServerState) { self._state = state }
    
    // MARK: Transition
    
    public final func shouldTransition(
        from: TurnBasedBattleServerState,
        to: TurnBasedBattleServerState
    )
    -> Bool {
        
        switch (from, to) {
            
        case
            (.end, .start),
            (.start, .turnStart),
            (.turnStart, .turnEnd),
            (.turnEnd, .turnStart),
            (.turnEnd, .end):
            
            return true
            
        default: return false
            
        }
            
    }
    
}

