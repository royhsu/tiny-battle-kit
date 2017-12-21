//
//  TBSession.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSession

public protocol TBSession {
    
    associatedtype Player: TBPlayer
    
    associatedtype Joined: TBJoined where Joined.Player == Player

    associatedtype Ready: TBReady where Ready.Player == Player
    
    var state: TBSessionState { get set }
    
    var owner: Player { get }
    
    var joineds: [Joined] { get }
    
    var readys: [Ready] { get }
    
}
