//
//  TBServerEventResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBServerEventEmitter

public protocol TBServerEventEmitter {
    
    func emit()
    
}

public struct TBAnyServerEventEmitter<Listener: AnyObject> {
    
    public typealias Action = (Listener) -> () -> Void
    
    // MARK: Property
    
    private weak var _listener: Listener?
    
    private let _action: Action
    
    // MARK: Init
    
    public init(
        listener: Listener,
        action: @escaping Action
    ) {
        
        self._listener = listener
        
        self._action = action
        
    }
    
}

// MARK: - TBAnyServerEventEmitter

extension TBAnyServerEventEmitter: TBServerEventEmitter {
    
    public func emit() {
     
        guard let listener = _listener else { return }
        
        _action(listener)()
        
    }
    
}
