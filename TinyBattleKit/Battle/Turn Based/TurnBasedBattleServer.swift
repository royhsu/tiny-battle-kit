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
// 4. [Bug] the client will .turnEnd twice when the client involves after the owner involved.

public final class TurnBasedBattleServer: BattleServer {
    
    // MARK: ValidateResult
    
    public enum ValidateResult {
        
        // MARK: Case
        
        case success(currentTurn: TurnBasedBattleTurn)
        
        case failure(Error)
        
    }
    
    // MARK: Property
    
    internal final let stateMachine: TurnBasedBattleServerStateMachine
    
    public final let player: BattlePlayer
    
    public private(set) final var record: TurnBasedBattleRecord {
        
        didSet {
            
            if stateMachine.state != record.state {
                
                stateMachine.state = record.state
                
            }
            
            serverDelegate?.server(
                self,
                didUpdate: record
            )
            
            if shouldEndCurrentTurn {
                
                record = serverDataProvider.setState(
                    .turnEnd,
                    forRecordId: record.id
                )
                
            }
            
        }
        
    }
    
    private final var observationToken: ObservationToken?
    
    private final let timeoutTimeInterval: TimeInterval = 10.0
    
    private final var timeoutTimer: Timer?
    
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
        
        timeoutTimer?.invalidate()
        
        observationToken?.invalidate()
        
    }
    
    // MARK: Helper
    
    private final var shouldEndCurrentTurn: Bool {
        
        guard
            isOwner,
            stateMachine.state == .turnStart
        else { return false }
        
        switch validate() {
        
        case .success(let currentTurn):
            
            guard
                !record.readys.isEmpty,
                !currentTurn.involveds.isEmpty
            else { return false }
            
            let readyPlayerIds = Set(
                record.readys.map { $0.player.id }
            )
            
            let involvedPlayerIds = Set(
                currentTurn.involveds.map { $0.player.id }
            )
            
            return readyPlayerIds == involvedPlayerIds
            
        case .failure(let error):
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
            return false
            
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
        
        let now = Date()
        
        let leeway = now.timeIntervalSince(self.record.updatedAtDate)
        
        let isTimeout = (leeway > timeoutTimeInterval)
        
        if isTimeout {
            
            let error: TurnBasedBattleServerError = .serverTimeout
            
            return .failure(error)
            
        }
        
        return .success(currentTurn: currentTurn)
        
    }
    
    public final func resume() {

        let isNewBattle = record.turns.isEmpty
        
        if isOwner && isNewBattle {
        
            record = serverDataProvider.appendTurnForRecord(id: record.id)
        
        }
        
        switch validate() {
        
        case .success(let currentTurn):
            
            timeoutTimer = Timer.scheduledTimer(
                withTimeInterval: timeoutTimeInterval,
                repeats: true,
                block: { [unowned self] timer in
                    
                    if self.isOwner {
                       
                        // Onwer keeps the server remaining online by updating updatedAtDate field.
                        self.record = self.serverDataProvider.setState(
                            self.stateMachine.state,
                            forRecordId: self.record.id
                        )
                        
                    }
                    
                }
            )
            
            observationToken = serverDataProvider.observeRecord(
                id: record.id,
                handler: { [weak self] updatedRecord in
                    
                    guard
                        let strongSelf = self
                    else { return }
                    
                    strongSelf.record = updatedRecord
                    
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
                    
                    serverDelegate?.server(
                        self,
                        didStartTurn: currentTurn
                    )
                    
                case .turnEnd:
                    
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
                
            if let request = request as? JoinedBattleRequest {
                
                supportedPromise = PlayerJoinBattleRequestResponder(server: self).respond(to: request)
            
            }
            else if let request = request as? ReadyBattleRequest {
                
                supportedPromise = PlayerReadyBattleRequestResponder(server: self).respond(to: request)
            
            }
            else if let request = request as? InvolvedBattleRequest {
                
                supportedPromise = PlayerInvolveBattleRequestResponder(
                        server: self,
                        currentTurn: currentTurn
                    )
                    .respond(to: request)
                
            }
            else if let request = request as? ContinueBattleRequest {
                
                supportedPromise = ContinueBattleRequestResponder(server: self).respond(to: request)
                
            }
            else if let request = request as? NextTurnBattleRequest {
                
                supportedPromise = NextTurnBattleRequestResponder(server: self).respond(to: request)
                
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
            
            promise.then(in: .main) { response in
                
                self.serverDelegate?.server(
                    self,
                    didRespondTo: request
                )
                
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
                
                // Todo: respond by request manually
//                let shouldEnd =
//                    serverDelegate?.serverShouldEnd(self)
//                    ?? false
//
//                if !shouldEnd && isOwner {
//
//                    record = serverDataProvider.appendTurnForRecord(id: record.id)
//
//                    record = serverDataProvider.setState(
//                        .turnStart,
//                        forRecordId: record.id
//                    )
//
//                }
//                else {
//
//                    record = serverDataProvider.setState(
//                        .end,
//                        forRecordId: record.id
//                    )
//
//                }
            
            case (.turnEnd, .end):
                
                serverDelegate?.serverDidEnd(self)
            
            default: fatalError("Invalid state transition.")
                
            }
            
        case .failure(let error):
            
            serverDelegate?.server(
                self,
                didFailWith: error
            )
            
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
