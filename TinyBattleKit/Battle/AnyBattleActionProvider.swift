//
//  AnyBattleActionProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AnyBattleActionProvider

public final class AnyBattleActionProvider
<Result: BattleResult>:
BattleActionProvider {
    
    // MARK: Property
    
    public final var priority: Double
    
    private final let _applyAction: (_ result: Result) -> Result
    
    // MARK: Init
    
    public init<Provider: BattleActionProvider>(_ provider: Provider)
    where Provider.Result == Result {
        
        self.priority = provider.priority
        
        self._applyAction = provider.applyAction
    
    }
    
    // MARK: BattleActionProvider
    
    public func applyAction(on result: Result) -> Result { return _applyAction(result) }
    
}
