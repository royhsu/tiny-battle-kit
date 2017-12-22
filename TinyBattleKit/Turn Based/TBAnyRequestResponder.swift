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

    private var _session: Session
    
    private let _respondToRequest: (Request) -> Promise<Response>
    
    // MARK: Init

    public init
        <Responder: TBRequestResponder>
        (_ responder: Responder)
        where Responder.Session == S {
            
        self._session = responder.session

        self._respondToRequest = responder.respond

    }

    // MARK: Forwarding
    
    public var session: Session {
        
        get { return _session }
        
        set { _session = newValue }
        
    }

    public func respond(to request: Request) -> Promise<Response> { return _respondToRequest(request) }

}
