//
//  ContinueBattleRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ContinueBattleRequestResponder

public struct ContinueBattleRequestResponder {
    
    // MARK: Property
    
    public let server: TurnBasedBattleServer
    
    // MARK: BattleRequestResponder
    
    public func respond(to request: BattleRequest) -> Promise<TurnBasedBattleResponse> {
        
        let server = self.server
        
        let dataProvider = server.serverDataProvider
        
        return Promise(in: .main) { fulfull, reject, _ in
            
            guard
                let request = request as? ContinueBattleRequest
            else {
                
                let error: TurnBasedBattleServerError = .invalidBattleRequest
                
                reject(error)
                
                return
                    
            }
            
            let requiredState: TurnBasedBattleServerState = .start
            
            if server.stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            guard
                server.record.owner.id == request.owner.id
            else {
                
                let error: TurnBasedBattleServerError = .onwerRequiredBattleRequest
                
                reject(error)
                
                return
                
            }
            
            let updatedRecord = dataProvider.setState(
                .turnStart,
                forRecordId: server.record.id
            )
            
            fulfull(
                TurnBasedBattleResponse(updatedRecord: updatedRecord)
            )
            
        }
        
    }
    
}
