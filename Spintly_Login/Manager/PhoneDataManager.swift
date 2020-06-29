//
//  PhoneDataManager.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import Reachability
import SwiftKeychainWrapper

class PhoneDataManager {
    
    private let reachability = Reachability()!
    private var isRunning = false
    private var isVerified = false
    static let shared = PhoneDataManager()
    
    private init() {
        
    }
    
    func start() {
        guard !isRunning else {
            return
        }
        reachability.whenReachable = { reachability in
            print("Network came online")
            if (UserManager.shared().userLoginState != .LoggedIn) {
                return
            }
            if (!self.isPhoneInfoUploaded()) {
                self.updatePhoneInfo()
            } else if (!self.isVerified){
                self.verifyPhone()
            }
        }
        reachability.whenUnreachable = { reachability in
            print("Network down")
        }
        try! reachability.startNotifier()
        isRunning = true
    }
    
    func stop() {
        guard isRunning else {
            return
        }
        reachability.stopNotifier()
        isRunning = false
    }
    
    private func isPhoneInfoUploaded() -> Bool {
        guard let existingDataDict = UserDefaults.standard.object(forKey: "iPhoneData") as? Data else {
            return false
        }
        let decoder = JSONDecoder()
        guard let existingData = try? decoder.decode(iPhoneData.self, from: existingDataDict) else {
            return false
        }
        print("currentData=\(iPhoneData.getCurrentDeviceDetails())")
        print("savedData=\(existingData)")
        return iPhoneData.getCurrentDeviceDetails() == existingData
    }
    
    func saveCurrentPhoneData() {
        guard let data = try? JSONEncoder().encode(iPhoneData.getCurrentDeviceDetails()) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "iPhoneData")
    }
    func updatePhoneInfo() {
        print("updatePhoneInfo")
        do {
            var dict : [String : Any] = [:]
            let phoneData = iPhoneData.getCurrentDeviceDetails()
            dict["endpointARN"] = (UserDefaults.standard.object(forKey: "endpointArnForSNS") as! String)
            dict["appVersion"] = Bundle.main.versionNumber
            dict["appPlatform"] = "iOS"
            dict["appNotifParserVersion"] = "1"
            dict["deviceUUID"] = getUniqueDeviceId()

            let jsonData = try JSONEncoder().encode(phoneData)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
            
            dict["deviceData"] = jsonDict
            
            APIManager.shared().postRequestWithJsonUrl("v1/users/currentDevice", method: .post, andParameters: dict, withCompletion: { response in
                
                if response.status {
                    let responseDic = response.object! as [String: Any]
                    print(responseDic["message"] as Any)
                    let responseDetailDic = responseDic["message"] as! [String: Any]
                    let userDetailDic = responseDetailDic["user"] as! [String: Any]
                    let userOrganisations = responseDetailDic["organisations"] as! [[String: Any]]
                    
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: userOrganisations)
                    if (userOrganisations.count == 0) {
                        let emptyPermissionArray : [AnyObject] = []
                        let dummyOrganisationObject = ["id": -1, "location": "", "name": "Spintly Smart Access", "permissions":emptyPermissionArray, "type":"", "userRole":"end_user"] as [String : Any]
                        var defaultDummyOrganisationForNewUser = [[String : Any]]()
                        defaultDummyOrganisationForNewUser.append(dummyOrganisationObject)
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: defaultDummyOrganisationForNewUser)
                        UserManager.shared().setOrganisationDicData(organisationsDic: encodedData)
                    } else {
                        UserManager.shared().setOrganisationDicData(organisationsDic: encodedData)
                    }
                    UserManager.shared().setDicData(userdetailDic: userDetailDic)
                    self.saveCurrentPhoneData()
                    
                    var id = userOrganisations[0]["id"] as! Int
                    if let lastOrganisation = Utils.getCurrentOrganisationDataDetails() {
                        for element in userOrganisations {
                            if lastOrganisation.id == element["id"] as! Int {
                                id = lastOrganisation.id
                                break
                            }
                        }
                    }
                    
                    UserManager.shared().setCurrentOrganisation(id: id)
                                        
                } else if (response.statusCode == 401) {
                    UserManager.shared().userLoginState = .SessionInvalidated
                }
            })
        } catch let error {
            print(error)
        }
    }
    
    func verifyPhone() {
        print("verifyPhone")
        var dict : [String : Any] = [:]
        dict["deviceUUID"] = getUniqueDeviceId()
        APIManager.shared().postRequestWithJsonUrl("users/verifyDevice", method: .post, andParameters: dict, withCompletion: { response in
            if response.status {
                self.isVerified = true
            } else if response.statusCode == 401 {
                UserManager.shared().userLoginState = .SessionInvalidated
            }
        })

    }
    
    func getUniqueDeviceId() -> String {
        if let key = UserDefaults.standard.string(forKey: "deviceUUID") {
            return key
        } else {
            let key = getUUIDofDeviceFromKeychain()
            UserDefaults.standard.set(key, forKey: "deviceUUID")
            return key
        }
    }
    
    private func getUUIDofDeviceFromKeychain() -> String {
        //Check is uuid present in keychain or not
        if let deviceId: String = KeychainWrapper.standard.string(forKey: "deviceUUID") {
            return deviceId
        }else{
            // if uuid is not present then get it and store it into keychain
            let key : String = UUID().uuidString
            let saveSuccessful: Bool = KeychainWrapper.standard.set(key, forKey: "deviceUUID")
            print("Save was successful: \(saveSuccessful)")
            return key
        }
    }
    
}
