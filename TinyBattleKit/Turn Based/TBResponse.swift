//
//  TBResponse.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBResponse

public protocol TBResponse {
    
    associatedtype Request: TBRequest
    
    var request: Request { get }
    
}
