//
//  TBSession.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSession

public protocol TBSession {
    
    associatedtype Ready: TBReady, Hashable
    
    associatedtype Joined: TBJoined, Hashable where Joined.Player == Ready.Player
    
    typealias Player = Ready.Player
    
    var state: TBSessionState { get set }
    
    var owner: Player { get }
    
    var created: Date { get }
    
    var updated: Date { get set }
    
    var joineds: Set<Joined> { get set }

    var readys: Set<Ready> { get set }
    
}
