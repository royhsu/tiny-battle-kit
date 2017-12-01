//
//  AnyBattleActionProvider.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AnyBattleActionProvider

public class AnyBattleActionProvider
<Result: BattleResult>: BattleActionProvider {
    
    // MARK: Property
    
    private let _applyAction: (_ result: Result) -> Result
    
    // MARK: Init
    
    public init<Provider: BattleActionProvider>(
        _ provider: Provider
        )
        where Provider.Result == Result {
            
            self._applyAction = provider.applyAction
            
    }
    
    // MARK: BattleActionProvider
    
    public func applyAction(on result: Result) -> Result { return _applyAction(result) }
    
}
