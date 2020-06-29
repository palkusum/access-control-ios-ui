//
//  AddUserViewModel.swift
//  Spintly
//
//  Created by Anees Ahmed on 12/06/20.
//  Copyright © 2020 MRINQ. All rights reserved.
//

import Foundation

class AddUserViewModel {
    var organisationId : Int!
    var attributeList = [AttributeModel]()
    var reportingManagers = [UserManagementModel]()
    var selectedReportingManagerIndex = -1
    var selectedAttributeValueIndexes = [Int : Int]()
    var barriers = [AccessBarrierModel]()
    var assignedRoles : Set<USER_PRIVILEGE> = [.end_user, .end_user]
    var name = ""
    var email = ""
    var phoneNumber = ""
    var mobileAccess : Bool?
    
    var saveOnSuccessCompletion : (()->())?
    
    func fetchFormData(completion : ((_ errorMessage : String?) -> ())? = nil) {
        
        let url = "/organisations/\(organisationId!)/users/new"
        APIManager.shared().getRequestWithUrl(url, method: .get, andParameters: [:]) { response in
            if (response.status) {
                
                let message = response.object!["message"] as! [String : Any]
                
                let attributesJsonArray = message["attributes"] as! [[String : Any]]
                self.attributeList = attributesJsonArray.map { AttributeModel(object: $0) }
                self.selectedAttributeValueIndexes = [:]
                
                let managersJsonArray = message["reportingManagers"] as! [[String : Any]]
                self.reportingManagers = managersJsonArray.map { UserManagementModel(object: $0) }
                self.selectedReportingManagerIndex = -1
                
                let barriersJsonArray = message["access_barriers"] as! [[String : Any]]
                self.barriers = barriersJsonArray.map { AccessBarrierModel(object: $0) }
                completion?(nil)

            } else {
                completion?(response.errorMessage)
            }
        }
    }

    func addUser(completion : ((_ errorMessage : String?) -> ())? = nil) {
        
        var jsonDic = [String: Any]()
        var newUserDictArray = [[String: Any]]() as Array

        var dict = [String: Any]()
        
        dict["name"] = name
        dict["email"] = email
        dict["phone"] = phoneNumber
        dict["privileges"] = assignedRoles.map {$0.rawValue}
        dict["access_barriers"] = barriers.filter({ $0.isSelected }).map{ $0.id }
        dict["onlyNfc"] = !mobileAccess!
        if (selectedReportingManagerIndex >= 0) {
            dict["reportingTo"] = reportingManagers[selectedReportingManagerIndex].id
        }
        
        let attributes = attributeList.filter {
            selectedAttributeValueIndexes[$0.id] != nil && selectedAttributeValueIndexes[$0.id]! >= 0
        }
        let attributesDict : [[String : Any]] = attributes.map {
            var dict = [String : Any]()
            dict["id"] = $0.id
            dict["attributeName"] = $0.attributeName
            dict["values"] = [$0.values[selectedAttributeValueIndexes[$0.id]!]]
            return dict
        }
        if attributesDict.count > 0 {
            dict["attributes"] = attributesDict
        }
        newUserDictArray.append(dict)
        jsonDic["users"] = newUserDictArray
        
        print("check here=====>")
        print(jsonDic)
        
        let url = "v1/organisations/\(organisationId!)/users"
        
        APIManager.shared().postRequestWithJsonUrl(url, method: .post, andParameters: jsonDic, withCompletion: { response in
            
            if response.status {
                completion?(nil)
                self.saveOnSuccessCompletion?()
            }else {
                completion?(response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED)
            }
            
        })
    }

}
