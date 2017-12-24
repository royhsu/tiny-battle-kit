//
//  TBServerError.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARL: - TBServerError

public enum TBServerError<Session: TBSession>: Error {
    
    public typealias Response = TBResponse<Session>
    
    public typealias Request = Response.Request
    
    public typealias Player = Session.Player
    
    // MARK: Case
    
    case badRequest(Request)
    
    case unsupportedRequest(Request)
    
    case requiredState(TBSessionState)
    
    case notJoined(Player)
    
    case currentTurnNotFound
    
    case requiredPermission(TBSessionPermission)
    
}
