//
//  TBJoined.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBJoined

public protocol TBJoined {
    
    associatedtype Player: TBPlayer
    
    var player: Player { get }
    
}
