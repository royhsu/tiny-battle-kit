//
//  TBJoinedRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBJoinedRequestResponder

public struct TBJoinedRequestResponder<S: TBSession> {
    
    public typealias Session = S
    
    public typealias Joined = Session.Joined
    
    // MARK: Property
    
    public var session: Session
    
    // MARK: Init
    
    public init(session: Session) { self.session = session }
    
}

// MARK: - TBRequestResponder

extension TBJoinedRequestResponder: TBRequestResponder {
    
    public typealias Error = TBServerError<Session.Player>
    
    public func respond(to request: Request) -> Promise<Response> {
        
        return Promise { fulfill, reject, _ in
            
            let requiredState: TBSessionState = .start
            
            if self.session.state != requiredState {
                
                let error: Error = .requiredState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            guard
                let joined = request.data as? Joined
            else {
                
                let error: TBServerError = .badRequest(request)
                
                reject(error)
                
                return
                
            }
            
            self.session.joineds.insert(joined)
            
            self.session.updated = Date()
            
            let response = Response(request: request)
            
            fulfill(response)
            
        }
        
    }
    
}
