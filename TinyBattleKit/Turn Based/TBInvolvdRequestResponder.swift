//
//  TBInvolvdRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 24/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBInvolvedRequestResponder

public struct TBInvolvedRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S
    
    public typealias Turn = Session.Turn
    
    public typealias Involved = Turn.Involved
    
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
                let involved = request.data as? Involved
            else {
                
                let error: Error = .badRequest(request)
                
                reject(error)
                
                return
                    
            }
            
            var updatedSession = request.session
            
            guard
                updatedSession.turns.last != nil
            else {
                
                let error: Error = .currentTurnNotFound
                
                reject(error)
                
                return
                
            }
            
            var updatedCurrentTurn = updatedSession.turns.removeLast()
            
            updatedCurrentTurn.involveds.insert(involved)
            
            updatedSession.turns.append(updatedCurrentTurn)
            
            updatedSession.updated = Date()
            
            let response = Response(
                request: request,
                session: updatedSession
            )
            
            fulfill(response)
            
        }
        
    }
    
}
