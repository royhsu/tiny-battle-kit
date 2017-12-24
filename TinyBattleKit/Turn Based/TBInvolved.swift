//
//  TBInvolved.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 24/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBInvolved

public protocol TBInvolved {
    
    associatedtype Player: TBPlayer, Hashable
    
    var player: Player { get }
    
}
