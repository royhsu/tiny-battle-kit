//
//  TBSession.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSession

public protocol TBSession: class {
    
    associatedtype Joined: TBJoined

    associatedtype Ready: TBReady where Ready.Player == Joined.Player
    
    typealias Player = Joined.Player
    
    var state: TBSessionState { get set }
    
    var owner: Player { get }
    
    var joineds: [Joined] { get set }

    var readys: [Ready] { get set }
    
    func save() -> Promise<Self>
    
}
