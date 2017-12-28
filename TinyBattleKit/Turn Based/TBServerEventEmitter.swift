//
//  TBServerEventResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBServerEventEmitter

public protocol TBServerEventEmitter {
    
    func emit(by trigger: Any)
    
}
