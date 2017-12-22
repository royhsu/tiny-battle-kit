//
//  TBServerError.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARL: - TBServerError

public enum TBServerError<Player: TBPlayer>: Error {
    
    public typealias Request = TBRequest<Player>
    
    // MARK: Case
    
    case badRequest(Request)
    
    case unsupportedRequest(Request)
    
    case requiredState(TBSessionState)
    
}

