//
//  TBResponse.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBResponse

public struct TBResponse<Player: TBPlayer> {

    public typealias Request = TBRequest<Player>

    // MARK: Property

    public let request: Request

    // MARK: Init

    public init(request: Request) { self.request = request }

}

