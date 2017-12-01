//
//  TurnBasedBattleServer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerDelegate

public protocol TurnBasedBattleServerDelegate: class {
    
    func serverDidStart(_ server: TurnBasedBattleServer)
    
    func server(
        _ server: TurnBasedBattleServer,
        didStartTurn turn: Int
    )
    
    func server(
        _ server: TurnBasedBattleServer,
        didEndTurn turn: Int
    )
    
    func serverShouldEnd(_ server: TurnBasedBattleServer) -> Bool
    
    func serverDidEnd(_ server: TurnBasedBattleServer)
    
    func server(
        _ server: TurnBasedBattleServer,
        didRespondTo request: BattleRequest
    )
    
    func server(
        _ server: TurnBasedBattleServer,
        didFailWith error: Error
    )
    
}

// MARK: - TurnBasedBattleServerError

public enum TurnBasedBattleServerError: Error {
    
    // MARK: Case
    
    case serverDataProviderNotFound
    
    case battleOwnerNotFound(ownerId: String)
    
    case battlePlayerNotFound(playerId: String)
    
    case battleRecordNotFound(recordId: String)
    
    case unsupportedBattleRequest
    
}

// MARK: - TurnBasedBattleServer

public final class TurnBasedBattleServer: BattleServer {
    
    // MARK: Property
    
    internal final var state: TurnBasedBattleServerState { return stateMachine.state }
    
    private final var stateMachine = TurnBasedBattleServerStateMachine(state: .end)
    
    public final weak var serverDataProvider: TurnBasedBattleServerDataProvider?
    
    public final let ownerId: String
    
    public final let recordId: String
    
    public final var owner: BattlePlayer?
    
    public final var record: TurnBasedBattleRecord?
    
    public private(set) final var joinedPlayers: [BattlePlayer] = []
    
    public final weak var serverDelegate: TurnBasedBattleServerDelegate?
    
    // MARK: Init
    
    public init(
        ownerId: String,
        recordId: String
    ) {
        
        self.ownerId = ownerId
        
        self.recordId = recordId
        
        stateMachine.machineDelegate = self
        
    }
    
    // MARK: BattleServer
    
    public final func resume() {
        
        guard
            let serverDataProvider = serverDataProvider
        else {
            
            let error: TurnBasedBattleServerError = .serverDataProviderNotFound
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
            return
            
        }
        
        guard
            let owner = serverDataProvider.fetchPlayer(id: ownerId)
        else {
            
            let error: TurnBasedBattleServerError = .battleOwnerNotFound(ownerId: ownerId)
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
            return
            
        }
        
        guard
            let record = serverDataProvider.fetchRecord(id: recordId)
        else {
            
            let error: TurnBasedBattleServerError = .battleRecordNotFound(recordId: recordId)
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
            return
                
        }
        
        self.owner = owner
        
        self.record = record
        
        serverDataProvider.updateServerState(.online)

        stateMachine.state = .start
        
    }
    
    public final func respond(to request: BattleRequest) {
        
        guard
            let serverDataProvider = serverDataProvider
        else {
            
            let error: TurnBasedBattleServerError = .serverDataProviderNotFound
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
            return
                
        }
        
        if let request = request as? JoinBattleRequest {
        
            let playerId = request.playerId
            
            guard
                let player = serverDataProvider.fetchPlayer(id: playerId)
            else {
                
                let error: TurnBasedBattleServerError = .battlePlayerNotFound(playerId: playerId)
                
                serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
            
            joinedPlayers.append(player)
            
            serverDelegate?.server(
                self,
                didRespondTo: request
            )
            
            return
            
        }
        
        let error: TurnBasedBattleServerError = .unsupportedBattleRequest
        
        serverDelegate?.server(
            self,
            didFailWith: error
        )
        
    }
    
}

// MARK: - BattleServerStateMachineDelegate

extension TurnBasedBattleServer: TurnBasedBattleServerStateMachineDelegate {
    
    public final func machine(
        _ machine: TurnBasedBattleServerStateMachine,
        didTransitionFrom from: TurnBasedBattleServerState,
        to: TurnBasedBattleServerState
    ) {
        
        switch (from, to) {
            
        case (.end, .start):
            
            serverDelegate?.serverDidStart(self)
            
        default: fatalError("Invalid state transition.")
            
        }
        
    }
    
    public final func machine(
        _ machine: TurnBasedBattleServerStateMachine,
        didFailWith error: Error
    ) {
       
        serverDelegate?.server(
            self,
            didFailWith: error
        )
        
    }
    
}
