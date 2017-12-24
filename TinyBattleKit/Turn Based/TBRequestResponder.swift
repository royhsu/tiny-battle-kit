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
    
    typealias Response = TBResponse<Session>
    
    typealias Request = Response.Request
    
    func respond(
        in context: Context,
        to request: Request
    )
    -> Promise<Response>
    
}
