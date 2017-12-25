//
//  TBTurn.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 24/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBTurn

public protocol TBTurn {
    
    associatedtype Involved: TBInvolved, Hashable
    
    associatedtype Queued: TBQueued, Hashable where Queued.Player == Involved.Player
    
    associatedtype Result: TBResult, Hashable where Result.Player == Involved.Player
    
    var involveds: Set<Involved> { get set }
    
    var queueds: [Queued] { get set }
    
    var results: [Result] { get set }
    
}
