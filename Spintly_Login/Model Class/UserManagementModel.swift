//
//  UserManagementModel.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation

class UserManagementModel {
    
    var email: String
    var id: String
    var name: String
    var phone: String
    var role: String
    var createdAt: String
    var employeeCode: String
    var isSignedUp: Bool
    var privileges: [String]
    var access_barriers: [[String: Any]]
    var reportingTo: UserManagementModel?
    var attributes: [AttributeModel]
    
    var allPriviledges : String {
        get {
            var shouldAddEndUser = true
            if (privileges.count > 1 && privileges.contains(USER_PRIVILEGE.end_user.rawValue)) {
                shouldAddEndUser = false;
            }
            var text = "";
            for privilegeString in privileges {
                let privilegeValue = USER_PRIVILEGE(rawValue: privilegeString)
                guard let privilege = privilegeValue else {
                    continue
                }
                
                if privilege == .end_user, !shouldAddEndUser {
                    continue
                }
                if !text.isEmpty {
                    text.append("/")
                }
                text.append(privilege.description)
            }
            return text
        }
    }
    
    init() {
        
        email = ""
        id = ""
        name = ""
        phone = ""
        role = ""
        createdAt = ""
        employeeCode = ""
        isSignedUp = false
        privileges = []
        access_barriers = [[:]]
        attributes = []
    }
    
    init(object: [String: Any]) {
        
        email = (object["email"] as? String) ?? ""
        id = (object["id"] as? String) ?? ""
        name = (object["name"] as? String) ?? ""
        phone = (object["phone"] as? String) ?? ""
        role = (object["role"] as? String) ?? ""
        createdAt = (object["createdAt"] as? String) ?? ""
        employeeCode = (object["employeeCode"] as? String) ?? ""
        isSignedUp = (object["isSignedUp"] as? Bool) ?? false
        privileges = (object["privileges"] as? [String]) ?? []
        access_barriers = (object["access_barriers"] as? [[String: Any]]) ?? [[:]]
        if let reportingToDict = object["reportingTo"] as? [String : Any] {
            reportingTo = UserManagementModel(object: reportingToDict)
        }
        let attributesDict = object["attributes"] as? [[String : Any]] ?? []
        attributes = attributesDict.map {AttributeModel(object: $0)}
        
    }
    
}

