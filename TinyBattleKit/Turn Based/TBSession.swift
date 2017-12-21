//
//  TBSession.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSession

public protocol TBSession {
    
    associatedtype Joined: TBJoined
    
    var state: TBSessionState { get set }
    
    var joineds: [Joined] { get }
    
}
