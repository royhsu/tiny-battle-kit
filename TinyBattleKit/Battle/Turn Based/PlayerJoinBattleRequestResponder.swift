//
//  PlayerJoinBattleRequestResponder.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 08/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PlayerJoinBattleRequestResponder

public struct PlayerJoinBattleRequestResponder {
    
    // MARK: Property
    
    public let server: TurnBasedBattleServer
    
    // MARK: BattleRequestResponder
    
    public func respond(to request: PlayerJoinBattleRequest) -> Promise<TurnBasedBattleResponse> {
        
        let server = self.server
        
        let dataProvider = server.serverDataProvider
        
        return Promise(in: .main) { fulfull, reject, _ in
            
            let requiredState: TurnBasedBattleServerState = .start
            
            if server.stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                reject(error)
                
                return
                
            }
            
            let playerId = request.joined.player.id
            
            let hasPlayerJoined = server
                .record
                .joineds
                .contains { $0.player.id == playerId }

            if hasPlayerJoined {

                let error: TurnBasedBattleServerError = .battlePlayerHasJoined(playerId: playerId)

                reject(error)

                return

            }
            
            let updatedRecord = dataProvider.appendJoined(
                request.joined,
                forRecordId: server.record.id
            )
            
            fulfull(
                TurnBasedBattleResponse(updatedRecord: updatedRecord)
            )
            
        }
        
    }
    
}
