//
//  AccessLogModel.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//



import Foundation
import RealmSwift

class AccessLogModel : Object {
    @objc dynamic var organisationId : Int = 0
    @objc dynamic var barrierId : Int = 0
    @objc dynamic var direction : String = ""
    @objc dynamic var accessedAt : String = ""
    @objc dynamic var delayed : Bool = false
    @objc dynamic var autoTimeSet : Bool = false //TODO:- Figure out how to determine if phone time is set to auto or manual
    @objc dynamic var requestUuid : String = ""
    @objc dynamic var method : String = ""
//    required init(){
//
//    }
//
    static func generateLog(inOrganisation organisationId : Int, forBarrier barrierId : Int, withDirection direction : String, at time : String, isDelayed : Bool = false, isTimeSetToAuto : Bool = true, method : String = "OPEN BUTTON") -> AccessLogModel {
        let log = AccessLogModel()
        log.organisationId = organisationId
        log.barrierId = barrierId
        log.direction = direction
        log.delayed = isDelayed
        log.accessedAt = time
        log.autoTimeSet = isTimeSetToAuto
        log.requestUuid = UUID().uuidString
        log.method = method
        return log
    }

    static func generateLog(inOrganisation organisationId : Int, forBarrier barrierId : Int, withDirection direction : String, at time : Date, isDelayed : Bool = false, isTimeSetToAuto : Bool = true, method : String = "OPEN BUTTON") -> AccessLogModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.DATE_TIME_ZONE_FORMAT
        let accessedAt = dateFormatter.string(from: time)
        return generateLog(inOrganisation: organisationId, forBarrier: barrierId, withDirection: direction, at: accessedAt, isDelayed: isDelayed, isTimeSetToAuto: isTimeSetToAuto)
    }
    
    func toDict() -> [String : Any] {
        var data = [String : Any]()
        data["organisationId"] = self.organisationId
        data["barrierId"] = self.barrierId
        data["direction"] = self.direction
        data["accessedAt"] = self.accessedAt
        data["delayed"] = self.delayed
        data["autoTimeSet"] = self.autoTimeSet
        data["deviceFwV"] = ""
        data["requestUuid"] = self.requestUuid
        data["method"] = self.method
        return data
    }
}
