//
//  OrganisationModel.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation

class OrganisationModel {
    
    var id: Int
    var name: String
    var location: String
    var type: String
    var userRole: String
    var permissions: [[String: Any]]
    var mobileAccessDenied: Bool
    var deviceLockMismatch: Bool
    
    init() {
        
        id = 0
        name = ""
        location = ""
        type = ""
        userRole = ""
        permissions = [[:]]
        mobileAccessDenied = false
        deviceLockMismatch = false
    }
    
    init(object: [String: Any]) {
        
        id = (object["id"] as? Int) ?? 0
        name = (object["name"] as? String) ?? ""
        location = (object["location"] as? String) ?? ""
        type = (object["type"] as? String) ?? ""
        userRole = (object["userRole"] as? String) ?? ""
        permissions = (object["permissions"] as? [[String: Any]]) ?? [[:]]
        mobileAccessDenied = (object["onlyNfc"] as? Bool) ?? false
        deviceLockMismatch = (object["deviceLockMismatch"] as? Bool) ?? false
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any] ()
        dict["id"] = id
        dict["name"] = name
        dict["location"] = location
        dict["type"] = type
        dict["userRole"] = userRole
        dict["permissions"] = permissions
        dict["onlyNfc"] = mobileAccessDenied
        dict["deviceLockMismatch"] = deviceLockMismatch
        
        return dict
    }
    
}
