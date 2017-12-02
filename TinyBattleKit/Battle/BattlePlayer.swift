//
//  BattlePlayer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattlePlayer

public protocol BattlePlayer {
    
    var id: String { get }
    
}

// MARK: - Equatable (Default Implementation)

extension BattlePlayer where Self: Equatable {
    
    public static func ==(
        lhs: Self,
        rhs: Self
    )
    -> Bool { return lhs.id == rhs.id }
    
}
