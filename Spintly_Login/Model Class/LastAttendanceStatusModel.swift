//
//  LastAttendanceStatusModel.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import RealmSwift

class LastAttendanceStatusModel : Object {
    
    @objc dynamic var organisationId : Int = 0
    @objc dynamic var forDate : Date?
    @objc dynamic var currentStatus : String?
    
    override static func primaryKey() -> String? {
        return "organisationId"
    }
    
}
