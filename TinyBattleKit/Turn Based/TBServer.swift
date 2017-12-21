//
//  TBServer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARL: - TBServerError

public enum TBServerError<Player: TBPlayer>: Error {
    
    // MARK: Case
    
    case unsupportedRequest(TBRequest<Player>)
    
}

// MARK: - TBServer

open class TBServer<Session: TBSession> {
    
    public typealias Player = Session.Player
    
    // MARK: Property
    
    public private(set) final var session: Session
    
    private final let stateMachine = TBSessionStateMachine(state: .end)
    
    // MARK: Init
    
    public init(session: Session) {
        
        self.session = session
        
        self.session.state = stateMachine.state
        
    }
    
}

public extension TBServer {
    
    public final func resume() {
        
        do {
            
            try stateMachine.transit(to: .start)
            
            session.state = stateMachine.state
            
        }
        catch { fatalError("\(error)") }
        
    }
    
}

// MARK: - Request

public extension TBServer {
    
    public typealias Response = TBResponse<Player>
    
    public typealias Reqeust = Response.Request
    
    public final func respond(to request: Reqeust) -> Promise<Response> {
        
        return Promise { fulfill, reject, _ in
            
            if let joined = request.data as? Session.Joined {
                
                fulfill(
                    TBResponse(request: request)
                )
                
            }
            else {
                
                let error: TBServerError = .unsupportedRequest(request)
                
                reject(error)
                
            }
            
        }
        
    }

}
