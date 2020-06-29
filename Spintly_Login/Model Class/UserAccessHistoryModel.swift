//
//  UserAccessHistoryModel.swift
//  Spintly
//
//  Created by Suhas Patil on 13/04/19.
//  Copyright © 2019 LeoMetric Technology. All rights reserved.
//

import Foundation

class UserAccessHistoryModel {
    
    
    var id : String
    var AccessBarrier : [String: Any]
    var accessedAt : String
    var createdAt : String
    var delayed : String
    var direction : String
    var source : String
    var accessBarrier : [String: Any]
    
    init() {
        
        id = ""
        AccessBarrier = [:]
        accessedAt = ""
        createdAt = ""
        delayed = ""
        direction = ""
        source = ""
        accessBarrier = [:]
    }
    
    init(object: [String: Any]) {
        
        id = (object["id"] as? String) ?? ""
        AccessBarrier = (object["AccessBarrier"] as? [String: Any]) ?? [:]
        accessedAt = (object["accessedAt"] as? String) ?? ""
        direction = (object["direction"] as? String) ?? ""
        delayed = ((object["delayed"]) as? String) ?? ""
        createdAt = (object["createdAt"] as? String) ?? ""
        source = (object["source"] as? String) ?? ""
        accessBarrier = (object["accessBarrier"] as? [String: Any]) ?? [:]
    }
    
}
