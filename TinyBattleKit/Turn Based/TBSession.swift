//
//  TBSession.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBSession

public protocol TBSession: class {
    
    associatedtype Ready: TBReady
    
    associatedtype Joined: TBJoined where Joined.Player == Ready.Player
    
    typealias Player = Ready.Player
    
    var state: TBSessionState { get set }
    
    var owner: Player { get }
    
    var created: Date { get }
    
    var updated: Date { get set }
    
    var joineds: [Joined] { get set }

    var readys: [Ready] { get set }
    
    func save() -> Promise<Self>
    
}
