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
        didStartTurn turn: TurnBasedBattleTurn
    )
    
    func server(
        _ server: TurnBasedBattleServer,
        didEndTurn turn: TurnBasedBattleTurn
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

// MARK: - TurnBasedBattleServer

// Todo:
// 1. Constantly verify state of owner and joined players.
// 2. Disconnect the server while its owner drops connection.
// 3. Set a timeout for each turn.

public final class TurnBasedBattleServer: BattleServer {
    
    // MARK: Property
    
    public final var state: TurnBasedBattleServerState { return stateMachine.state }
    
    private final var stateMachine = TurnBasedBattleServerStateMachine(state: .end)
    
    public final let ownerId: String
    
    public final let recordId: String
    
    public final var owner: BattlePlayer?
    
    public final var record: TurnBasedBattleRecord?
    
    public private(set) final var joinedPlayers: [BattlePlayer] = []
    
    public final weak var serverDataProvider: TurnBasedBattleServerDataProvider?
    
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
    
    // MARK: Helper
    
    private final var shouldEndCurrentTurn: Bool {
        
        guard
            let currentTurn = record?.turns.last,
            !joinedPlayers.isEmpty,
            !currentTurn.involvedPlayers.isEmpty
        else {
            
            let error: TurnBasedBattleServerError = .battleCurrentTurnNotFound(recordId: recordId)
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
            return false
            
        }
    
        let joinedPlayerIds = joinedPlayers.map { $0.id }
        
        let involvedPlayerIds = currentTurn.involvedPlayers.map { $0.id }
        
        return joinedPlayerIds == involvedPlayerIds
        
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
        
        joinedPlayers = [ owner ]
        
        let isNewBattle = record.turns.isEmpty
        
        self.record =
            isNewBattle
            ? serverDataProvider.addNewTurnForRecord(id: recordId)
            : record
            
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
            
            let requiredState: TurnBasedBattleServerState = .start
            
            if stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
        
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
        
        if let request = request as? ContinueBattleRequest {
            
            let requiredState: TurnBasedBattleServerState = .start
            
            if stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
            
            guard
                request.ownerId == ownerId
            else {
                
                let error: TurnBasedBattleServerError = .permissionDenied
                
                serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
            
            serverDelegate?.server(
                self,
                didRespondTo: request
            )
            
            stateMachine.state = .turnStart
            
            return
            
        }
        
        if let request = request as? PlayerInvolvedRequest {
            
            let requiredState: TurnBasedBattleServerState = .turnStart
            
            if stateMachine.state != requiredState {
                
                let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
                
                serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
            
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
            
            guard
                let currentTurn = record?.turns.last
            else {
                
                let error: TurnBasedBattleServerError = .battleCurrentTurnNotFound(recordId: recordId)
                
                serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
            
            let hasPlayerInvovled = currentTurn.involvedPlayers.contains { $0.id == playerId }
            
            if hasPlayerInvovled {
                
                let error: TurnBasedBattleServerError = .battlePlayerHasInvolvedCurrentTurn(playerId: playerId)
                
                serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
            
            self.record = serverDataProvider.addInvolvedPlayer(
                player,
                forCurrentTurnOfRecordId: recordId
            )
            
            serverDelegate?.server(
                self,
                didRespondTo: request
            )
            
            if shouldEndCurrentTurn { stateMachine.state = .turnEnd }
            
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
            
        case
            (.start, .turnStart),
            (.turnEnd, .turnStart):
        
            let currentTurn = record!.turns.last!
            
            serverDelegate?.server(
                self,
                didStartTurn: currentTurn
            )
            
        case (.turnStart, .turnEnd):
            
            let currentTurn = record!.turns.last!
            
            serverDelegate?.server(
                self,
                didEndTurn: currentTurn
            )
            
            let shouldEnd =
                serverDelegate?.serverShouldEnd(self)
                ?? false
            
            if !shouldEnd { record = serverDataProvider!.addNewTurnForRecord(id: recordId) }
            
            stateMachine.state =
                shouldEnd
                ? .end
                : .turnStart
            
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
