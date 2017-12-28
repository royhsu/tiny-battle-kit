//
//  TBSession.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSession

public protocol TBSession {
    
    associatedtype Joined: TBJoined, Hashable
    
    associatedtype Ready: TBReady, Hashable where Ready.Player == Joined.Player
    
    associatedtype Turn: TBTurn, Hashable where Turn.Involved.Player == Joined.Player
    
    typealias Player = Joined.Player
    
    var state: TBSessionState { get set }
    
    var owner: Player { get }
    
    var created: Date { get }
    
    var updated: Date { get set }
    
    var joineds: Set<Joined> { get set }

    var readys: Set<Ready> { get set }
    
    var turns: [Turn] { get set }
    
}
