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
                
                let error: TBServerError = .badRequest(request)
                
                reject(error)
                
                return
                    
            }
            
            var updatedTurns = request.session.turns
            
            guard
                let currentTurn = updatedTurns
                    .sorted(
                        by: { $0.created > $1.created }
                    )
                    .first,
                var updatedCurrentTurn = updatedTurns.remove(currentTurn)
            else {
                
                let error: Error = .currentTurnNotFound
                
                reject(error)
                
                return
                
            }
            
            updatedCurrentTurn.involveds.insert(involved)
            
            updatedTurns.insert(updatedCurrentTurn)
            
            var updatedSession = request.session
            
            updatedSession.turns = updatedTurns
            
            updatedSession.updated = Date()
            
            let response = Response(
                request: request,
                session: updatedSession
            )
            
            fulfill(response)
            
        }
        
    }
    
}
