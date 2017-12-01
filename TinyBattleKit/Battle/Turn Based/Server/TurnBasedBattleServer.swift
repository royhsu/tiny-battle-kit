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

// MARK: - TurnBasedBattleServer

public final class TurnBasedBattleServer: BattleServer {
    
    // MARK: Property
    
    internal final var state: TurnBasedBattleServerState { return stateMachine.state }
    
    private final var stateMachine = TurnBasedBattleServerStateMachine(state: .end)
    
    public final weak var serverDelegate: TurnBasedBattleServerDelegate?
    
    // MARK: BattleServer
    
    public final func resume() {
        
        stateMachine.machineDelegate = self
        
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
        
    }
    
    public final func machine(
        _ machine: TurnBasedBattleServerStateMachine,
        didFailWith error: Error
    ) {
        
    }
    
}
