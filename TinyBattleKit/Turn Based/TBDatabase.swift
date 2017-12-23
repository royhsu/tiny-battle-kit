//
//  TBDatabase.swift
//  TinyBattleKit
//
//  Created by Roy Hsu on 23/12/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TBDatabase

public protocol TBDatabase {
    
    // Update the object in the database and insert it while the database can't not find it.
    func upsert<Object>(_ object: Object) -> Promise<Object>
    
}
