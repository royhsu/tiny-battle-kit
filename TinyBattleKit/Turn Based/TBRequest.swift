//
//  TBRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBRequest

public struct TBRequest<Player: TBPlayer> {

    // MARK: Property

    public let player: Player

    public let data: Any

    // MARK: Init

    public init(
        player: Player,
        data: Any
    ) {

        self.player = player

        self.data = data

    }

}
