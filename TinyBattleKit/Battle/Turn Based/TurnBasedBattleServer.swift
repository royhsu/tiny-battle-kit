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

// MARK: - TurnBasedBattleServer

// Todo:
// 1. Constantly verify state of owner and joined players.
// 2. Disconnect the server while its owner drops connection.
// 3. Set a timeout for each turn.

public final class TurnBasedBattleServer: BattleServer {
    
    // MARK: ValidateResult
    
    public enum ValidateResult {
        
        // MARK: Case
        
        case success(currentTurn: TurnBasedBattleTurn)
        
        case failure(Error)
        
    }
    
    // MARK: Property
    
    // Todo: timer to keep alive.
    public final var state: BattleServerState {
        
        let isNewRecord = (record.createdAtDate == record.updatedAtDate)
        
        if isNewRecord { return .offline }
        
        // todo: switch machine state.
        
        let now = Date()
        
        let serverOnlineTimeout = now.timeIntervalSince(record.updatedAtDate)
            
        return
            serverOnlineTimeout <= 10.0
            ? .online
            : .offline
        
    }
    
    internal final let stateMachine: TurnBasedBattleServerStateMachine
    
    public final let player: BattlePlayer
    
    public private(set) final var record: TurnBasedBattleRecord
    
    private final var observationToken: ObservationToken?
    
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
        
        let isOwner = (player.id == record.owner.id)
        
        if isOwner {
        
            // Todo:
            // 1. leverage the usage of online / offline state.
            // 2. maybe replace machine state with generic sever state online / offline? but two states might be too limited.
            self.record =
                record.state == .end
                ? record
                : dataProvider.setState(
                    .end,
                    forRecordId: record.id
                )
            
            self.stateMachine = .init(state: .end)
            
            self.record = dataProvider.resetJoinedAndReadyPlayersForRecord(id: record.id)
            
        }
        else {
            
            self.record = record
            
            self.stateMachine = .init(state: record.state)
            
        }
        
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
                !currentTurn.involvedPlayers.isEmpty
            else { return false }
        
            let readyPlayerIds = record.readyPlayers.map { $0.id }
            
            let involvedPlayerIds = currentTurn.involvedPlayers.map { $0.id }
            
            return readyPlayerIds == involvedPlayerIds
            
        case .failure(let error):
            
            fatalError("Server is now invalid. \(error)")
            
        }
        
    }
    
    // MARK: BattleServer
    
    public final func validate() -> ValidateResult {
        
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

        let isNewBattle = record.turns.isEmpty
        
        if isOwner && isNewBattle {
        
            record = serverDataProvider.appendTurnForRecord(id: record.id)
        
        }
        
        switch validate() {
        
        case .success:
            
            observationToken = serverDataProvider.observeRecord(
                id: record.id,
                handler: { [weak self] updatedRecord in
                    
                    guard
                        let strongSelf = self
                    else { return }
                    
                    strongSelf.record = updatedRecord
                    
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
                    forRecordId: record.id
                )
                
            }
            else {
                
                // Sync client and server state.
                switch record.state {
                    
                case .start:
                    
                    serverDelegate?.serverDidStart(self)
                    
                case .turnStart:
                    
                    let currentTurn = record.turns.last!
                    
                    serverDelegate?.server(
                        self,
                        didStartTurn: currentTurn
                    )
                    
                case .turnEnd:
                    
                    let currentTurn = record.turns.last!
                    
                    serverDelegate?.server(
                        self,
                        didEndTurn: currentTurn
                    )
                    
                case .end:
                    
                    serverDelegate?.serverDidEnd(self)
                    
                }
                
            }
            
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
        
            var supportedPromise: Promise<TurnBasedBattleResponse>?
            
            switch request {
                
            case is PlayerJoinBattleRequest:
                
                supportedPromise = PlayerJoinBattleRequestResponder(
                        server: self
                    )
                    .respond(to: request)
                
            case is PlayerReadyBattleRequest:
                
                supportedPromise = PlayerReadyBattleRequestResponder(
                        server: self
                    )
                    .respond(to: request)
                
            case is PlayerInvolveBattleRequest:
                
                supportedPromise = PlayerInvolveBattleRequestResponder(
                        server: self,
                        currentTurn: currentTurn
                    )
                    .respond(to: request)
                
            case is ContinueBattleRequest:
                
                supportedPromise = ContinueBattleRequestResponder(server: self).respond(to: request)
                
            default: break
                
            }
            
            guard
                let promise = supportedPromise
            else {
                
                let error: TurnBasedBattleServerError = .unsupportedBattleRequest
                
                self.serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
                return
                
            }
            
            promise.then(in: .main) {
                
                self.record = $0.updatedRecord
                
                self.serverDelegate?.server(
                    self,
                    didRespondTo: request
                )
                
                if self.shouldEndCurrentTurn {

                    self.record = self.serverDataProvider.setState(
                        .turnEnd,
                        forRecordId: self.record.id
                    )

                }
                
            }
            .catch(in: .main) { error in
                
                self.serverDelegate?.server(
                    self,
                    didFailWith: error
                )
                
            }
            
        case .failure(let error):
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
        }
        
    }
    
}

public extension TurnBasedBattleServer {
    
    public final var isOwner: Bool { return player.id == record.owner.id }
    
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
                        forRecordId: record.id
                    )
                    
                }
                else {
                    
                    record = serverDataProvider.setState(
                        .end,
                        forRecordId: record.id
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
