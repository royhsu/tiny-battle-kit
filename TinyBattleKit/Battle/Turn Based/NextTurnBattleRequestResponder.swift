//
//  NextTurnBattleRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 12/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - NextTurnBattleRequestResponder

public struct NextTurnBattleRequestResponder {
    
    // MARK: Property
    
    public let server: TurnBasedBattleServer
    
    // MARK: BattleRequestResponder
    
    public func respond(to request: NextTurnBattleRequest) -> Promise<TurnBasedBattleResponse> {
        
        let server = self.server
        
        let dataProvider = server.serverDataProvider
        
        return Promise(in: .main) { fulfull, reject, _ in
            
            let requiredState: TurnBasedBattleServerState = .turnEnd
            
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
            
            let _ = dataProvider.appendTurnForRecord(id: server.record.id)

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
