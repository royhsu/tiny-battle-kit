//
//  TBTurnRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 24/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBTurnRequestResponder

public struct TBTurnRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S
    
    public typealias Turn = Session.Turn
    
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
                let turn = request.data as? Turn
            else {
                
                let error: TBServerError = .badRequest(request)
                
                reject(error)
                
                return
                    
            }
            
            let isOwner = (request.session.owner == request.player)
            
            guard isOwner else {
                
                let error: Error = .requiredPermission(.administrator)
                
                reject(error)
                
                return
                
            }
            
            var updatedSession = request.session
            
            updatedSession.turns.insert(turn)
            
            updatedSession.updated = Date()
            
            let response = Response(
                request: request,
                session: updatedSession
            )
            
            fulfill(response)
            
        }
        
    }
    
}
