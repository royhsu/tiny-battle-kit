//
//  TBRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBRequestResponder

public protocol TBRequestResponder {
    
    associatedtype Session: TBSession
    
    typealias Player = Session.Player
    
    typealias Response = TBResponse<Player>
    
    typealias Request = Response.Request
    
    var session: Session { get set }
    
    func respond(to request: Request) -> Promise<Response>
    
}
