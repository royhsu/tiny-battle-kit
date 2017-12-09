//
//  PlayerReadyBattleRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PlayerReadyBattleRequestResponder

public struct PlayerReadyBattleRequestResponder {
    
    // MARK: Property
    
    public let server: TurnBasedBattleServer
    
    // MARK: BattleRequestResponder
    
    public func respond(to request: ReadyBattleRequest) -> Promise<TurnBasedBattleResponse> {
        
        let server = self.server
        
        let dataProvider = server.serverDataProvider
        
        return Promise(in: .main) { fulfull, reject, _ in
            
            let requiredState: TurnBasedBattleServerState = .start
            
            if server.stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            let playerId = request.ready.player.id
            
            let isPlayerReady = server
                .record
                .readys
                .contains { $0.player.id == playerId }
            
            if isPlayerReady {
                
                let error: TurnBasedBattleServerError = .battlePlayerIsReady(playerId: playerId)
                
                reject(error)
                
                return
                
            }
            
            let updatedRecord = dataProvider.appendReady(
                request.ready,
                forRecordId: server.record.id
            )
            
            fulfull(
                TurnBasedBattleResponse(updatedRecord: updatedRecord)
            )
            
        }
        
    }
    
}
