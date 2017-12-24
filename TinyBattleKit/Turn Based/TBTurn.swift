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
    
    var involveds: Set<Involved> { get set }
    
}
