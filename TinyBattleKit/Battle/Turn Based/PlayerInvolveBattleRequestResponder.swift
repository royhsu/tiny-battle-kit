//
//  PlayerInvolveBattleRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PlayerInvolveBattleRequestResponder

public struct PlayerInvolveBattleRequestResponder {
    
    // MARK: Property
    
    public let server: TurnBasedBattleServer
    
    public let currentTurn: TurnBasedBattleTurn
    
    // MARK: BattleRequestResponder
    
    public func respond(to request: PlayerInvolveBattleRequest) -> Promise<TurnBasedBattleResponse> {
        
        let server = self.server
        
        let dataProvider = server.serverDataProvider
        
        return Promise(in: .main) { fulfull, reject, _ in
            
            let requiredState: TurnBasedBattleServerState = .turnStart
            
            if server.stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            let playerId = request.involved.player.id
            
            let hasPlayerInvovled = self.currentTurn
                .involveds
                .contains { $0.player.id == playerId }
            
            if hasPlayerInvovled {
                
                let error: TurnBasedBattleServerError = .battlePlayerHasInvolved(playerId: playerId)
                
                reject(error)
                
                return
                
            }
            
            let updatedRecord = dataProvider.appendInvolved(
                request.involved,
                forCurrentTurnOfRecordId: server.record.id
            )
            
            fulfull(
                TurnBasedBattleResponse(updatedRecord: updatedRecord)
            )
            
        }
        
    }
    
}
