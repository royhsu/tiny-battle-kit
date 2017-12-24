//
//  TBResult.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 24/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBResult

public protocol TBResult {
    
    associatedtype Player: TBPlayer, Hashable
    
    var player: Player { get }
    
}
