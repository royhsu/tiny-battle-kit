//
//  TBServerEvent.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBServerEvent

public enum TBServerEvent {
    
    // MARK: Case
    
    // The server chagned its session state.
    case stateChanged
    
    // The server changed its session.
    case sessionChanged
    
    // The server sent a response for one of the previous requests.
    case responseSent
    
}
