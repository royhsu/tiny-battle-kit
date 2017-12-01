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
    
}

// MARK: - TurnBasedBattleServer

public final class TurnBasedBattleServer: BattleServer {
    
    // MARK: Property
    
    internal final var state: TurnBasedBattleServerState { return stateMachine.state }
    
    private final var stateMachine = TurnBasedBattleServerStateMachine(state: .end)
    
    public final weak var serverDataProvider: TurnBasedBattleServerDataProvider?
    
    public final weak var serverDelegate: TurnBasedBattleServerDelegate?
    
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
        
        serverDataProvider.updateServerState(.online)
        
        stateMachine.machineDelegate = self
        
        stateMachine.state = .start
        
    }
    
    public final func respond(to request: BattleRequest) {
        
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
