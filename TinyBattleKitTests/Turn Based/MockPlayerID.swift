//
//  MockPlayerID.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockPlayerID

import TinyCore

internal struct MockPlayerID: ID {
    
    internal typealias RawValue = String
    
    // MARK: Property
    
    internal let rawValue: RawValue
    
    // MARK: Init
    
    internal init(_ rawValue: RawValue) { self.rawValue = rawValue }
    
}
