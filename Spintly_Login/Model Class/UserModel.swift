//
//  UserModel.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation

class UserModel {
    
    var email: String
    var id: String
    var name: String
    var phone: String
    
    init() {
        
        email = ""
        id = ""
        name = ""
        phone = ""
    }
    
    init(object: [String: Any]) {
        
        email = (object["email"] as? String) ?? ""
        id = (object["id"] as? String) ?? ""
        name = (object["name"] as? String) ?? ""
        phone = (object["phone"] as? String) ?? ""
        
    }
    
    
}


class Utils {
    
    class func getLoggedInUserDetails() -> UserModel {
        
        var userObject = UserModel()
        
        if let userDetailDict = UserDefaults.standard.dictionary(forKey: "UserdetailDic") {
            userObject = UserModel(object: userDetailDict)
        }
      
        return userObject
    }
    
    class func getOrganisationDetails() -> [OrganisationModel] {
        
        var organisationObject = [OrganisationModel]()
        if let outData = UserDefaults.standard.data(forKey: "organisationsDic"){
            let orgDic = NSKeyedUnarchiver.unarchiveObject(with: outData) as! [[String: Any]]
            for dic in orgDic {
                let object = OrganisationModel(object: dic)
                organisationObject.append(object)
            }
        }
        return organisationObject
    }
    
    class func getOrganisationDetailsDict() -> [[String : Any]] {
        if let outData = UserDefaults.standard.data(forKey: "organisationsDic"){
            return NSKeyedUnarchiver.unarchiveObject(with: outData) as! [[String: Any]]
        } else {
            return [[String : Any]]()
        }
    }
//    class func getCurrentOrganisationDetails() -> OrganisationModel {
//
//        var organisationObject = OrganisationModel()
//        if let orgDic = UserDefaults.standard.dictionary(forKey: "currentOrganisationsDic") {
//            organisationObject = OrganisationModel(object: orgDic)
//        }
//        return organisationObject
//    }
    
    class func getCurrentOrganisationDataDetails() -> OrganisationModel? {
        
        var organisationObject = OrganisationModel()
        if let outData = UserDefaults.standard.data(forKey: "currentOrganisationsDataDic") {
            let orgDic = NSKeyedUnarchiver.unarchiveObject(with: outData) as! [String: Any]
            organisationObject = OrganisationModel(object: orgDic)
        }
        return organisationObject ?? nil
    }
    
    class func getCurrentOrganisationDataDetailsDict() -> [String : Any]? {
        if let outData = UserDefaults.standard.data(forKey: "currentOrganisationsDataDic") {
            return NSKeyedUnarchiver.unarchiveObject(with: outData) as! [String: Any]
        } else {
            return nil
        }
    }
}
