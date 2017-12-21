//
//  TBServerError.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARL: - TBServerError

public enum TBServerError<Player: TBPlayer>: Error {
    
    // MARK: Case
    
    case unsupportedRequest(TBRequest<Player>)
    
}

