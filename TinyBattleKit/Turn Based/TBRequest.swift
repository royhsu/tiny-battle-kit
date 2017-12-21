//
//  TBRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBRequest

public protocol TBRequest {
    
    associatedtype Player: TBPlayer
    
    var player: Player { get }
    
}
