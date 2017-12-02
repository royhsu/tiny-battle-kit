//
//  StubTurnBasedBattleServerDelegate.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubTurnBasedBattleServerDelegate

import TinyBattleKit

internal final class StubTurnBasedBattleServerDelegate: TurnBasedBattleServerDelegate {
    
    internal typealias DidStart = (_ server: TurnBasedBattleServer) -> Void

    internal typealias DidStartTurn = (
        _ server: TurnBasedBattleServer,
        _ turn: TurnBasedBattleTurn
    )
    -> Void

    internal typealias DidEndTurn = (
        _ server: TurnBasedBattleServer,
        _ turn: TurnBasedBattleTurn
    )
    -> Void

    internal typealias ShouldEnd = (_ server: TurnBasedBattleServer) -> Bool

    internal typealias DidEnd = (_ server: TurnBasedBattleServer) -> Void

    internal typealias DidRespondToRequest = (
        _ server: TurnBasedBattleServer,
        _ request: BattleRequest
    )
    -> Void

    internal typealias DidFail = (
        _ server: TurnBasedBattleServer,
        _ error: Error
    )
    -> Void

    // MARK: Property
    
    internal final let didStart: DidStart?

    internal final let didStartTurn: DidStartTurn?
    
    internal final let didEndTurn: DidEndTurn?

    internal final let shouldEnd: ShouldEnd?
    
    internal final let didEnd: DidEnd?

    internal final let didRespondToRequest: DidRespondToRequest?

    internal final let didFail: DidFail?
    
    // MARK: Init
    
    internal init(
        didStart: DidStart?,
        didStartTurn: DidStartTurn?,
        didEndTurn: DidEndTurn?,
        shouldEnd: ShouldEnd?,
        didEnd: DidEnd?,
        didRespondToRequest: DidRespondToRequest?,
        didFail: DidFail?
    ) {

        self.didStart = didStart
        
        self.didStartTurn = didStartTurn
        
        self.didEndTurn = didEndTurn
        
        self.shouldEnd = shouldEnd
        
        self.didEnd = didEnd
        
        self.didRespondToRequest = didRespondToRequest
        
        self.didFail = didFail
        
    }

    // MARK: BattleServerDelegate
    
    internal final func serverDidStart(_ server: TurnBasedBattleServer) { didStart?(server) }

    internal final func server(
        _ server: TurnBasedBattleServer,
        didStartTurn turn: TurnBasedBattleTurn
    ) {
        
        didStartTurn?(
            server,
            turn
        )
        
    }

    internal final func server(
        _ server: TurnBasedBattleServer,
        didEndTurn turn: TurnBasedBattleTurn
    ) {
        
        didEndTurn?(
            server,
            turn
        )
        
    }

    internal final func serverShouldEnd(_ server: TurnBasedBattleServer) -> Bool {
        
        return
            shouldEnd?(server)
            ?? false
        
    }

    internal final func serverDidEnd(_ server: TurnBasedBattleServer) { didEnd?(server) }

    internal final func server(
        _ server: TurnBasedBattleServer,
        didRespondTo request: BattleRequest
    ) {
        
        didRespondToRequest?(
            server,
            request
        )
        
    }

    internal final func server(
        _ server: TurnBasedBattleServer,
        didFailWith error: Error
    ) {
        
        didFail?(
            server,
            error
        )
        
    }
    
}
