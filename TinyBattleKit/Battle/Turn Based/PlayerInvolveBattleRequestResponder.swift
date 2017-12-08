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
    
    public func respond(to request: BattleRequest) -> Promise<TurnBasedBattleResponse> {
        
        let server = self.server
        
        let dataProvider = server.serverDataProvider
        
        return Promise(in: .main) { fulfull, reject, _ in
            
            guard
                let request = request as? PlayerInvolveBattleRequest
            else {
                
                let error: TurnBasedBattleServerError = .invalidBattleRequest
                
                reject(error)
                
                return
                    
            }
            
            let requiredState: TurnBasedBattleServerState = .turnStart
            
            if server.stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            let playerId = request.player.id
            
            let hasPlayerInvovled = self.currentTurn
                .involvedPlayers
                .contains { $0.id == playerId }
            
            if hasPlayerInvovled {
                
                let error: TurnBasedBattleServerError = .battlePlayerHasInvolved(playerId: playerId)
                
                reject(error)
                
                return
                
            }
            
            let updatedRecord = dataProvider.appendInvolvedPlayer(
                request.player,
                forCurrentTurnOfRecordId: server.record.id
            )
            
            fulfull(
                TurnBasedBattleResponse(updatedRecord: updatedRecord)
            )
            
        }
        
    }
    
}