//
//  TBReadyRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBReadyRequestResponder

public struct TBReadyRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S
    
    public typealias Ready = Session.Ready
    
    public typealias Error = TBServerError<Session>
    
    // MARK: Respond
    
    public func respond(to request: Request) -> Promise<Response> {
        
        return Promise { fulfill, reject, _ in
            
            let requiredState: TBSessionState = .running
            
            if request.session.state != requiredState {
                
                let error: Error = .requiredState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            guard
                let ready = request.data as? Ready
            else {
                
                let error: TBServerError = .badRequest(request)
                
                reject(error)
                
                return
                    
            }
            
            let player = request.player
            
            let hasPlayerJoined = request.session
                .joineds
                .contains { $0.player == player }
            
            guard hasPlayerJoined else {
                
                let error: Error = .notJoined(player)
                
                reject(error)
                
                return
                
            }
            
            var updatedSession = request.session
            
            updatedSession.readys.insert(ready)
            
            updatedSession.updated = Date()
            
            let response = Response(
                request: request,
                session: updatedSession
            )
            
            fulfill(response)
            
        }
        
    }
    
}
