//
//  TBJoinedRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBJoinedRequestResponder

public struct TBJoinedRequestResponder<S: TBSession>: TBRequestResponder {
    
    public typealias Session = S
    
    // MARK: - Responder
    
    public func respond(to request: Request) -> Promise<Response> {
        
        return Promise { fulfill, reject, _ in
            
            guard
                let joined = request.data as? S.Joined
            else {
                
                let error: TBServerError = .badRequest(request)
                
                reject(error)
                
                return
                
            }
            
            let response = Response(request: request)
            
            fulfill(response)
            
        }
        
    }
    
}
