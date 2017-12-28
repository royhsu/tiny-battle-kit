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
    
    public final let database: TBDatabase
    
    // Please make to use the function transit(:) to change the state of the session and state machine.
    // NEVER to directly access them to change the state.
    public private(set) final var session: Session {
        
        didSet {
            
            let emitter = events[.sessionChanged]
            
            emitter?.emit(by: self)
            
        }
        
    }
    
    private final let stateMachine = TBSessionStateMachine(state: .idle)
    
    private final var events: [TBServerEvent: TBServerEventEmitter] = [:]
    
    private typealias ContextRequest = (context: Context, request: Request)
    
    private final var resolvingContextRequest: ContextRequest?
    
    private final var queuingTimer: Timer?
    
    private final var queuingContextRequests: [ContextRequest] = [] {
        
        didSet {
            
            if queuingContextRequests.isEmpty {
                
                queuingTimer?.invalidate()
                
                queuingTimer = nil
                
            }
            else {
                
                if queuingTimer == nil {
                    
                    queuingTimer = .scheduledTimer(
                        withTimeInterval: 1.0,
                        repeats: true,
                        block: { _ in self.resolveQueuedsIfNeeded() }
                    )
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: Init
    
    public init(
        database: TBDatabase,
        session: Session
    ) {
        
        self.database = database
        
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
            
            try stateMachine.transit(to: state)
            
            session.state = stateMachine.state
            
            let emitter = events[.stateChanged]
            
            emitter?.emit(by: self)
            
        }
        catch { fatalError("\(error)") }
        
    }
    
    public final func resume() { transit(to: .running) }
    
}

// MARK: - Request

public extension TBServer {
    
    public typealias Response = TBResponse<Session>
    
    public typealias Request = Response.Request
    
    public typealias Error = TBServerError<Session>
    
    public typealias JoineRequestResponder = TBJoinedRequestResponder<Session>
    
    public typealias ReadyRequestResponder = TBReadyRequestResponder<Session>
    
    public typealias TurnRequestResponder = TBTurnRequestResponder<Session>
    
    public typealias InvolvedRequestResponder = TBInvolvedRequestResponder<Session>
    
    public typealias QueuedRequestResponder = TBQueuedRequestResponder<Session>
    
    public typealias ResultRequestResponder = TBResultRequestResponder<Session>
    
    @discardableResult
    public final func respond(
        in context: Context,
        to request: Request
    )
    -> Self {
        
        let contextRequest = ContextRequest(context, request)
        
        queuingContextRequests.append(contextRequest)
        
        return self
        
    }
    
    private final func resolveQueuedsIfNeeded() {
        
        if
            queuingContextRequests.isEmpty
            && (resolvingContextRequest != nil)
        { return }

        let contextRequest = queuingContextRequests.removeFirst()
        
        resolvingContextRequest = contextRequest
        
        let context = contextRequest.context
        
        let request = contextRequest.request
        
        JoineRequestResponder()
            .respond(
                in: context,
                to: request
            )
            .recover(
                in: context,
                { _ in

                    return ReadyRequestResponder().respond(
                        in: context,
                        to: request
                    )

                }
            )
            .recover(
                in: context,
                { _ in

                    return TurnRequestResponder().respond(
                        in: context,
                        to: request
                    )

                }
            )
            .recover(
                in: context,
                { _ in

                    return InvolvedRequestResponder().respond(
                        in: context,
                        to: request
                    )

                }
            )
            .recover(
                in: context,
                { _ in

                    return QueuedRequestResponder().respond(
                        in: context,
                        to: request
                    )

                }
            )
            .recover(
                in: context,
                { _ in

                    return ResultRequestResponder().respond(
                        in: context,
                        to: request
                    )

                }
            )
            .then(in: context) { response in

                return self.database.upsert(
                    in: context,
                    with: response.session
                )

            }
            .then(in: context) { updatedSession in

                self.session = updatedSession

                let response = Response(
                    request: request,
                    session: updatedSession
                )

                let emitter = self.events[.responseSent]
                
                emitter?.emit(by: response)
                
            }
            .catch(in: context) { error in
                
                let emitter = self.events[.responseSent]
                
                emitter?.emit(by: error)
        
            }
            .always(in: context) { self.resolvingContextRequest = nil }
        
    }

}
