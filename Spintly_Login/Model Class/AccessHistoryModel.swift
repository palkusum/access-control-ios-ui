//
//  AccessHistoryModel.swift
//  Spintly
//
//  Created by Suhas Arvind Patil on 11/04/19.
//  Copyright © 2019 LeoMetric Technology. All rights reserved.
//

import Foundation

class AccessHistoryModel {
    
    var id : String
    var access_barrier_id : String
    var user_id : String
    var direction : String
    var AccessBarrier : [String:Any]
    var UserDetail : [String:Any]
    var accessedAt : String
    var source : String
    var delayed : Bool

    init() {
        
        id = ""
        access_barrier_id = ""
        user_id = ""
        direction = ""
        AccessBarrier = [:]
        UserDetail = [:]
        accessedAt = ""
        source = ""
        delayed = false

    }
    
    init(object: [String: Any]) {
        
        id = (object["id"] as? String) ?? ""
        access_barrier_id = (object["access_barrier_id"] as? String) ?? ""
        user_id = (object["user_id"] as? String) ?? ""
        direction = (object["direction"] as? String) ?? ""
        AccessBarrier = ((object["AccessBarrier"]) as? [String:Any]) ?? [:]
        UserDetail = (object["User"] as? [String:Any]) ?? [:]
        accessedAt = (object["accessedAt"] as? String) ?? ""
        source = (object["source"] as? String) ?? ""
        delayed = (object["delayed"] as? Bool) ?? false

    }
}
