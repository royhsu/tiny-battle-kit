//
//  TBReadyRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBReadyRequestResponder

public struct TBReadyRequestResponder<S: TBSession> {
    
    public typealias Session = S
    
    public typealias Ready = Session.Ready
    
    // MARK: Property
    
    public var session: Session
    
    // MARK: Init
    
    public init(session: Session) { self.session = session }
    
}

// MARK: - TBRequestResponder

extension TBReadyRequestResponder: TBRequestResponder {
    
    public typealias Error = TBServerError<Session.Player>
    
    public func respond(to request: Request) -> Promise<Response> {
        
        return Promise { fulfill, reject, _ in
            
            let requiredState: TBSessionState = .start
            
            if self.session.state != requiredState {
                
                let error: Error = .requiredState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            let player = request.player
            
            let hasPlayerJoined = self.session
                .joineds
                .contains { $0.player == player }
            
            guard hasPlayerJoined else {
                
                let error: Error = .notJoined(player)
                
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
            
            self.session.readys.insert(ready)
            
            self.session.updated = Date()
            
            let response = Response(request: request)
            
            fulfill(response)
            
        }
        
    }
    
}
