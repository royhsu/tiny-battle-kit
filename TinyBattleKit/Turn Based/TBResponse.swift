//
//  TBResponse.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 21/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBResponse

public struct TBResponse<Session: TBSession> {

    public typealias Request = TBRequest<Session>

    // MARK: Property

    public let request: Request
    
    public let session: Session

    // MARK: Init

    public init(
        request: Request,
        session: Session
    ) {
        
        self.request = request
        
        self.session = session
        
    }

}

