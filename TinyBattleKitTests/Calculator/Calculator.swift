//
//  Calculator.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 01/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - CalculatorAnimator

internal typealias CalculatorAnimator = DefaultBattleActionAnimator<CalculatorResult>

// MARK: - Calculator

import TinyBattleKit

internal final class Calculator: TurnBasedBattle<CalculatorAnimator> { }

