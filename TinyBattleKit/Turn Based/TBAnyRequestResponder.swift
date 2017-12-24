//
//  TBAnyRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBAnyRequestResponder

public struct TBAnyRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S

    // MARK: Property
    
    private let _respondToRequest: (Context, Request) -> Promise<Response>
    
    // MARK: Init

    public init
        <Responder: TBRequestResponder>
        (_ responder: Responder)
        where Responder.Session == S {

        self._respondToRequest = responder.respond

    }

    // MARK: Forwarding

    public func respond(
        in context: Context,
        to request: Request
    )
    -> Promise<Response> {
        
        return _respondToRequest(
            context,
            request
        )
        
    }

}
