//
//  TBJoinedRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBJoinedRequestResponder

public struct TBJoinedRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S
    
    public typealias Joined = Session.Joined
    
    public typealias Error = TBServerError<Session>
    
    // MARK: Responder
    
    public func respond(to request: Request) -> Promise<Response> {
        
        return Promise { fulfill, reject, _ in
            
            let requiredState: TBSessionState = .start
            
            if request.session.state != requiredState {
                
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
            
            var updatedSession = request.session
            
            updatedSession.joineds.insert(joined)
            
            updatedSession.updated = Date()
            
            let response = Response(
                request: request,
                session: updatedSession
            )
            
            fulfill(response)
            
        }
        
    }
    
}
