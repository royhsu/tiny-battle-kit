//
//  TBQueuedRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 25/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBQueuedRequestResponder

// Only the owner of a session can add a new queued.
public struct TBQueuedRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S
    
    public typealias Turn = Session.Turn
    
    public typealias Queued = Turn.Queued
    
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
                let queued = request.data as? Queued
            else {
                
                let error: Error = .badRequest(request)
                
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
            
            guard
                updatedSession.turns.last != nil
            else {
                
                let error: Error = .currentTurnNotFound
                
                reject(error)
                
                return
                    
            }
            
            var updatedCurrentTurn = updatedSession.turns.removeLast()
            
            updatedCurrentTurn.queueds.append(queued)
            
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
