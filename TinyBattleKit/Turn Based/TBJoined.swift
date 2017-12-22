//
//  TBJoined.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBJoined

public protocol TBJoined: class {
    
    associatedtype Player: TBPlayer, Hashable
    
    var player: Player { get }
    
}
