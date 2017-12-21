//
//  TBServer.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBServer

open class TBServer<Session: TBSession> {
    
    // MARK: Property
    
    public private(set) final var session: Session
    
    // MARK: Init
    
    public init(session: Session) { self.session = session }
    
}
