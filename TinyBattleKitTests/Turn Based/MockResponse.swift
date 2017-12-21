//
//  MockResponse.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - MockResponse

import TinyBattleKit

internal struct MockResponse: TBResponse {

    internal typealias Request = MockRequest
    
    // MARK: Property
    
    internal let request: Request
    
    // MARK: Init
    
    internal init(request: Request) { self.request = request }
    
}
