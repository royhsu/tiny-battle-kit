//
//  StubServerEventListener.swift
//  TinyBattleKitTests
//
//  Created by Roy Hsu on 22/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//


// MARK: - StubServerEventListener

internal final class StubServerEventListener {
    
    // MARK: Property
    
    internal final let _online: (_ trigger: Any) -> Void
    
    // MARK: Init
    
    init(
        online: @escaping (_ trigger: Any) -> Void
    ) { self._online = online }
    
    // MARK: Event
    
    internal final func online(_ trigger: Any) { _online(trigger) }
    
}
