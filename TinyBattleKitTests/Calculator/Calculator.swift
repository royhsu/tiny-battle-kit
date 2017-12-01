//
//  Calculator.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Calculator

import TinyBattleKit

internal final class Calculator: TurnBasedBattle {

    internal typealias Provider = AnyBattleActionProvider<CalculatorResult>
    
    // MARK: Property
    
    internal final var actionProviders: [Provider] = []
    
}