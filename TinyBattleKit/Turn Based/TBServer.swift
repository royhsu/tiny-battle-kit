//
//  TBServer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBServer

open class TBServer<Session: TBSession> {
    
    public typealias Player = Session.Player
    
    // MARK: Property
    
    // Please make to use the function transit(:) to change the state of the session and state machine.
    // NEVER to directly access them to change the state.
    public private(set) final var session: Session
    
    private final let stateMachine = TBSessionStateMachine(state: .end)
    
    private final var events: [TBServerEvent: TBServerEventEmitter] = [:]
    
    // MARK: Init
    
    public init(session: Session) {
        
        self.session = session
        
        self.session.state = stateMachine.state
        
    }

}

// MARK: - Event

public extension TBServer {
    
    @discardableResult
    public func addListener<Listener: AnyObject>(
        _ listener: Listener,
        action: @escaping (Listener) -> (Any) -> Void,
        for event: TBServerEvent
    )
    -> TBServer {
        
        events[event] = TBAnyServerEventEmitter(
            listener: listener,
            action: action
        )
        
        return self
        
    }
    
    @discardableResult
    public func removeListener(for event: TBServerEvent) -> TBServer {
        
        events[event] = nil
        
        return self
        
    }
    
}

public extension TBServer {
    
    // Keep the state between the session and the state machine in synchronization.
    private final func transit(to state: TBSessionState) {
        
        do {
            
            let old = session.state
            
            let new = state
            
            try stateMachine.transit(to: new)
            
            session.state = stateMachine.state
            
            switch (old, new) {
                
            case (.end, .start):
                
                let emitter = events[.online]
                
                emitter?.emit(by: self)
                
            default: break
                
            }
            
        }
        catch { fatalError("\(error)") }
        
    }
    
    public final func resume() { transit(to: .start) }
    
}

// MARK: - Request

public extension TBServer {
    
    public typealias Error = TBServerError<Player>
    
    public typealias Response = TBResponse<Player>
    
    public typealias Reqeust = Response.Request
    
    public typealias JoineRequestResponder = TBJoinedRequestResponder<Session>
    
    public typealias ReadyRequestResponder = TBReadyRequestResponder<Session>
    
    public final func respond(to request: Reqeust) -> Promise<Response> {
        
        let responders = [
            TBAnyRequestResponder(
                JoineRequestResponder(session: session)
            ),
            TBAnyRequestResponder(
                ReadyRequestResponder(session: session)
            )
        ]
        
        return async { _ in
            
            // Todo: throwing the error by a responder if it can handle request.
            // The current implementation alway throws unsupported request error while all responders failed.
            for responder in responders {
                
                guard
                    let response = try? ..responder.respond(to: request)
                else { continue }
                    
                return response
                
            }
            
            let error: Error = .unsupportedRequest(request)
            
            throw error
            
        }
        
    }

}
