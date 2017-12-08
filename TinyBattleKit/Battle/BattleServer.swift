//
//  BattleServer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BattleServer

public protocol BattleServer {
    
    func resume()
    
    func respond(to request: BattleRequest)
    
}

