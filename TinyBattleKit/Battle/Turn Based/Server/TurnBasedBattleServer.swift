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

// MARK: - ValidateServerResult

public enum ValidateServerResult {
    
    // MARK: Case
    
    case success(TurnBasedBattleServerDataProvider)
    
    case failure(Error)
    
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
    
    public final let player: BattlePlayer
    
    public private(set) final var record: TurnBasedBattleRecord
    
    public private(set) final var joinedPlayers: [BattlePlayer] = []
    
    public final weak var serverDataProvider: TurnBasedBattleServerDataProvider?
    
    public final weak var serverDelegate: TurnBasedBattleServerDelegate?
    
    // MARK: Init
    
    public init(
        player: BattlePlayer,
        record: TurnBasedBattleRecord
    ) {
        
        self.player = player
        
        self.record = record
        
        stateMachine.machineDelegate = self
        
    }
    
    // MARK: Helper
    
    private final var shouldEndCurrentTurn: Bool {
        
        let currentTurn = record.turns.last!
        
        guard
            !joinedPlayers.isEmpty,
            !currentTurn.involvedPlayers.isEmpty
        else { return false }
    
        let joinedPlayerIds = joinedPlayers.map { $0.id }
        
        let involvedPlayerIds = currentTurn.involvedPlayers.map { $0.id }
        
        return joinedPlayerIds == involvedPlayerIds
        
    }
    
    // MARK: BattleServer
    
    public final func validateServer() -> ValidateServerResult {
        
        if record.isLocked {
            
            let error: TurnBasedBattleServerError = .battleRecordIsLocked(recordId: record.id)
            
            return .failure(error)
            
        }
        
        guard
            let serverDataProvider = serverDataProvider
        else {
                
            let error: TurnBasedBattleServerError = .serverDataProviderNotFound
        
            return .failure(error)
                
        }
        
        return .success(serverDataProvider)
        
    }
    
    public final func resume() {
        
        switch validateServer() {
        
        case .success(let dataProvider):
        
            joinedPlayers = [ player ]
            
            let isNewBattle = record.turns.isEmpty
            
            if isNewBattle {
                
                let updatedRecord = dataProvider.addNewTurnForRecord(id: record.id)
                
                record = updatedRecord
                
            }
            
            stateMachine.state = .start
            
        case .failure(let error):
        
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
        }
        
    }
    
    public final func respond(to request: BattleRequest) {
        
        switch validateServer() {
            
        case .success(let dataProvider):
        
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
                    let player = dataProvider.fetchPlayer(id: playerId)
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
                    player.id == record.owner.id
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
                    let player = dataProvider.fetchPlayer(id: playerId)
                else {
                    
                    let error: TurnBasedBattleServerError = .battlePlayerNotFound(playerId: playerId)
                    
                    serverDelegate?.server(
                        self,
                        didFailWith: error
                    )
                    
                    return
                    
                }
                
                let currentTurn = record.turns.last!
                
                let hasPlayerInvovled = currentTurn.involvedPlayers.contains { $0.id == playerId }
                
                if hasPlayerInvovled {
                    
                    let error: TurnBasedBattleServerError = .battlePlayerHasInvolvedCurrentTurn(playerId: playerId)
                    
                    serverDelegate?.server(
                        self,
                        didFailWith: error
                    )
                    
                    return
                    
                }
                
                self.record = dataProvider.addInvolvedPlayer(
                    player,
                    forCurrentTurnOfRecordId: record.id
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
            
        case .failure(let error):
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
        }
        
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
        
            let currentTurn = record.turns.last!
            
            serverDelegate?.server(
                self,
                didStartTurn: currentTurn
            )
            
        case (.turnStart, .turnEnd):
            
            let currentTurn = record.turns.last!
            
            serverDelegate?.server(
                self,
                didEndTurn: currentTurn
            )
            
            let shouldEnd =
                serverDelegate?.serverShouldEnd(self)
                ?? false
            
            if !shouldEnd { record = serverDataProvider!.addNewTurnForRecord(id: record.id) }
            
            stateMachine.state =
                shouldEnd
                ? .end
                : .turnStart
            
        case (.turnEnd, .end):
            
            serverDelegate?.serverDidEnd(self)
            
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
