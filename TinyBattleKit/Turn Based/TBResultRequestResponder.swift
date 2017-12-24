//
//  TBResultRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 24/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBResultRequestResponder

public struct TBResultRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S
    
    public typealias Turn = Session.Turn
    
    public typealias Result = Turn.Result
    
    public typealias Error = TBServerError<Session>
    
    // MARK: Respond
    
    public func respond(
        in context: Context,
        to request: Request
    )
    -> Promise<Response> {
            
        return Promise(in: context) { fulfill, reject, _ in
            
            let requiredState: TBSessionState = .running
            
            if request.session.state != requiredState {
                
                let error: Error = .requiredState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            guard
                let result = request.data as? Result
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
            
            updatedCurrentTurn.results.insert(result)
            
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
