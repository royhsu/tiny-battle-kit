//
//  TBQueued.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 25/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBQueued

public protocol TBQueued {
    
    associatedtype Player: TBPlayer, Hashable
    
    var player: Player { get }
    
}
