//
//  PermissionModel.swift
//  Spintly
//
//  Created by Suhas Patil on 28/03/19.
//  Copyright © 2019 LeoMetric Technology. All rights reserved.
//

import Foundation

class PermissionModel {
    
    var createdAt: String
    var barrierId: String
    var userId: String
    var unlockSettings: [String: Any]
    var access_barrier: [String: Any]
    var singleUnitAttendance: Bool
    var exit_device: [[String: Any]]
    
    init() {
        
        createdAt = ""
        barrierId = ""
        userId = ""
        unlockSettings = [:]
        access_barrier = [:]
        singleUnitAttendance = false
        exit_device = [[:]]
    }
    
    init(object: [String: Any]) {
        
        createdAt = (object["createdAt"] as? String) ?? ""
        barrierId = (object["barrierId"] as? String) ?? ""
        userId = (object["userId"] as? String) ?? ""
        unlockSettings = (object["unlockSettings"] as? [String: Any]) ?? [:]
        access_barrier = (object["access_barrier"] as? [String: Any]) ?? [:]
        singleUnitAttendance = (object["singleUnitAttendance"] as? Bool) ?? false
        exit_device = (object["exit_device"] as? [[String: Any]]) ?? [[:]]
        
    }
    
}

//"createdAt": "2019-03-06T14:39:59.991Z",
//"barrierId": "66",
//"userId": "377",
//"remoteUnlockEnabled": false,
//"access_barrier": {
//    "id": "66",
//    "name": "uno unit 04",
//    "location": "Apartment",
//    "entry_device": {
//        "id": "25",
//        "mac_id": "f877567c96fc",
//        "encryptionKey": "3c22481b38cf76cb88b3451d70029a92",
//        "device_type": "door"
//    },
//    "exit_device": null
