//
//  TurnBasedBattleServer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TurnBasedBattleServerDelegate

public protocol TurnBasedBattleServerDelegate: class {
    
    func server(
        _ server: TurnBasedBattleServer,
        didUpdate record: TurnBasedBattleRecord
    )
    
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
    
    case success(currentTurn: TurnBasedBattleTurn)
    
    case failure(Error)
    
}

// MARK: - TurnBasedBattleServer

// Todo:
// 1. Constantly verify state of owner and joined players.
// 2. Disconnect the server while its owner drops connection.
// 3. Set a timeout for each turn.

public final class TurnBasedBattleServer: BattleServer {
    
    // MARK: Property
    
    private final let stateMachine: TurnBasedBattleServerStateMachine
    
    public final let player: BattlePlayer
    
    // Todo: observe data provider for record changes
    public private(set) final var record: TurnBasedBattleRecord
    
    public final var isOwner: Bool { return player.id == record.owner.id }
    
    private final var observationToken: ObservationToken?
    
    // Todo: add into record
    public private(set) final var joinedPlayers: [BattlePlayer] = []
    
    // Todo: add into record
    public private(set) final var readyPlayers: [BattlePlayer] = []
    
    public final unowned let serverDataProvider: TurnBasedBattleServerDataProvider
    
    public final weak var serverDelegate: TurnBasedBattleServerDelegate?
    
    // MARK: Init
    
    public init(
        dataProvider: TurnBasedBattleServerDataProvider,
        player: BattlePlayer,
        record: TurnBasedBattleRecord
    ) {
        
        self.serverDataProvider = dataProvider
        
        self.player = player
        
        self.record =
            record.state == .end
            ? record
            : dataProvider.setState(
                .end,
                forRecord: record.id
            )
        
        self.stateMachine = TurnBasedBattleServerStateMachine(state: record.state)
        
        self.stateMachine.machineDelegate = self
        
    }
    
    deinit {
        
        print(#function)
        
        observationToken?.invalidate()
        
    }
    
    // MARK: Helper
    
    private final var shouldEndCurrentTurn: Bool {
        
        switch validate() {
        
        case .success(let currentTurn):
            
            guard
                !readyPlayers.isEmpty,
                !currentTurn.involvedPlayers.isEmpty
            else { return false }
        
            let readyPlayerIds = readyPlayers.map { $0.id }
            
            let involvedPlayerIds = currentTurn.involvedPlayers.map { $0.id }
            
            return readyPlayerIds == involvedPlayerIds
            
        case .failure(let error):
            
            fatalError("Server is now invalid. \(error)")
            
        }
        
    }
    
    // MARK: BattleServer
    
    public final func validate() -> ValidateServerResult {
        
        if record.isLocked {
            
            let error: TurnBasedBattleServerError = .battleRecordIsLocked(recordId: record.id)
            
            return .failure(error)
            
        }
        
        guard
            let currentTurn = record.turns.last
        else { fatalError("A record must contains at least one turn.") }
        
        return .success(currentTurn: currentTurn)
        
    }
    
    public final func resume() {
        
        let requiredState: TurnBasedBattleServerState = .end
        
        if stateMachine.state != requiredState {
            
            let error: TurnBasedBattleServerError = .serverNotInState(requiredState)
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
            return
            
        }
        
        let isNewBattle = record.turns.isEmpty
        
        if isNewBattle {
        
            record = serverDataProvider.appendTurnForRecord(id: record.id)
        
        }
        
        switch validate() {
        
        case .success:
            
            observationToken = serverDataProvider.observeRecord(
                id: record.id,
                handler: { [weak self] in
                    
                    guard
                        let strongSelf = self
                    else { return }
                    
                    strongSelf.record = $0
                    
                    let currentState = strongSelf.stateMachine.state
                    
                    if currentState != strongSelf.record.state {
                        
                        strongSelf.stateMachine.state = strongSelf.record.state
                        
                    }
                    
                    strongSelf.serverDelegate?.server(
                        strongSelf,
                        didUpdate: strongSelf.record
                    )
                    
                }
            )
            
            if isOwner {
                
                record = serverDataProvider.setState(
                    .start,
                    forRecord: record.id
                )
                
            }
            else { stateMachine.state = .start }
            
        case .failure(let error):
        
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
        }
        
    }
    
    public final func respond(to request: BattleRequest) {
        
        switch validate() {
            
        case .success(let currentTurn):
        
            if let request = request as? PlayerJoinBattleRequest {
                
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
                
                let hasPlayerJoined = joinedPlayers.contains { $0.id == playerId }
                
                if hasPlayerJoined {
                    
                    let error: TurnBasedBattleServerError = .battlePlayerHasJoined(playerId: playerId)

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
            
            if let request = request as? PlayerReadyBattleRequest {
                
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
                
                let hasPlayerJoined = joinedPlayers.contains { $0.id == playerId }
                
                if !hasPlayerJoined {
                    
                    let error: TurnBasedBattleServerError = .battlePlayerNotJoined(playerId: playerId)
                    
                    serverDelegate?.server(
                        self,
                        didFailWith: error
                    )
                    
                    return
                    
                }
                
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
                
                let isPlayerReady = readyPlayers.contains { $0.id == playerId }
                
                if isPlayerReady {
                    
                    let error: TurnBasedBattleServerError = .battlePlayerIsReady(playerId: playerId)
                    
                    serverDelegate?.server(
                        self,
                        didFailWith: error
                    )
                    
                    return
                    
                }
                
                readyPlayers.append(player)
                
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
                    
                    let error: TurnBasedBattleServerError = .onwerRequiredBattleRequest
                    
                    serverDelegate?.server(
                        self,
                        didFailWith: error
                    )
                    
                    return
                    
                }
                
                record = serverDataProvider.setState(
                    .turnStart,
                    forRecord: record.id
                )
                
                serverDelegate?.server(
                    self,
                    didRespondTo: request
                )
                
                return
                
            }
            
            if let request = request as? PlayerInvolveBattleRequest {
                
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
                
                let hasPlayerInvovled = currentTurn.involvedPlayers.contains { $0.id == playerId }
                
                if hasPlayerInvovled {
                    
                    let error: TurnBasedBattleServerError = .battlePlayerHasInvolvedCurrentTurn(playerId: playerId)
                    
                    serverDelegate?.server(
                        self,
                        didFailWith: error
                    )
                    
                    return
                    
                }
                
                record = serverDataProvider.appendInvolvedPlayer(
                    player,
                    forCurrentTurnOfRecordId: record.id
                )
                
                if shouldEndCurrentTurn {
                    
                    record = serverDataProvider.setState(
                        .turnEnd,
                        forRecord: record.id
                    )
                    
                }
                
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
        
        switch validate() {
            
        case .success(let currentTurn):
            
            switch (from, to) {
                
            case (.end, .start):
                
                serverDelegate?.serverDidStart(self)
                
            case
                (.start, .turnStart),
                (.turnEnd, .turnStart):
                
                serverDelegate?.server(
                    self,
                    didStartTurn: currentTurn
                )
                
            case (.turnStart, .turnEnd):
                
                serverDelegate?.server(
                    self,
                    didEndTurn: currentTurn
                )
                
                let shouldEnd =
                    serverDelegate?.serverShouldEnd(self)
                    ?? false
                
                if !shouldEnd {
                    
                    record = serverDataProvider.appendTurnForRecord(id: record.id)
                    
                    record = serverDataProvider.setState(
                        .turnStart,
                        forRecord: record.id
                    )
                    
                }
                else {
                    
                    record = serverDataProvider.setState(
                        .end,
                        forRecord: record.id
                    )
                    
                }
            
            case (.turnEnd, .end):
                
                serverDelegate?.serverDidEnd(self)
            
            default: fatalError("Invalid state transition.")
                
            }
            
        case .failure(let error):
            
            fatalError("Server is now invalid. \(error)")
            
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
