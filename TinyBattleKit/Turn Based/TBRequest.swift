//
//  TBRequest.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBRequest

public struct TBRequest<Session: TBSession> {

    // MARK: Property

    public let player: Session.Player
    
    public let session: Session

    public let data: Any

    // MARK: Init

    public init(
        player: Session.Player,
        session: Session,
        data: Any
    ) {

        self.player = player
        
        self.session = session

        self.data = data

    }

}
