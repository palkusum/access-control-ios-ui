//
//  UserManager.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import UIKit
import AWSCognitoIdentityProvider

enum LoginState : NSString {
    case LoggedIn = "LOGGED_IN"
    case SessionInvalidated = "SESSION_INVALIDATED"
    case LoggedOut = "LOGGED_OUT"
}

class UserManager {
    
    var userloggedIn : NSString!
    private var _userLoginState : LoginState = .LoggedOut
    var userDetailDictionary : [String: Any]!
    static var manager : UserManager! = nil
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)


    class func shared() -> UserManager {
        
        if manager != nil {
            return manager!
        }
        manager = UserManager()
        
        // let str = UserDefaults.standard.object(forKey: "userLoggedIn")as! String
        
                        
            if let loginState = UserDefaults.standard.string(forKey: "userLoginState") {
                manager?.userLoginState = LoginState(rawValue: loginState as NSString)!
            } else {
                if (UserDefaults.standard.object(forKey: "userLoggedIn") != nil) && UserDefaults.standard.object(forKey: "userLoggedIn")as! String == "yes" {
                    manager?.userLoginState = .LoggedIn
                } else {
                    manager?.userLoginState = .LoggedOut
                }
            }
        
        NotificationCenter.default.addObserver(manager!, selector: #selector(onApplicationActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        return manager!
    }
    
    func setDicData(userdetailDic: [String: Any]){
        UserDefaults.standard.set(userdetailDic, forKey: "UserdetailDic") //setObject
    }
    
    func setOrganisationDicData(organisationsDic: Data){
        UserDefaults.standard.set(organisationsDic, forKey: "organisationsDic") //setObject
    }
    
    func setCurrentOrganisation(id : Int) {
        let organisationsDict = Utils.getOrganisationDetailsDict()
        for orgDict in organisationsDict {
            if (id == orgDict["id"] as! Int) {
                let encodeOrganisation = NSKeyedArchiver.archivedData(withRootObject: orgDict)
                setCurrentOrganisationDataDic(organisationsDic: encodeOrganisation)
                break;
            }
        }
    }
    
    func setCurrentOrganisationDataDic(organisationsDic: Data) {
        UserDefaults.standard.set(organisationsDic, forKey: "currentOrganisationsDataDic") //setObject
        NotificationCenter.default.post(name: Notification.Name(NotificationNames.ORGANISATION_CHANGED), object: nil)
    }
    
    //Use Custom
    func isLoggedIn() -> Bool{
        
        if (_userLoginState == .LoggedIn){
            return true
        }else{
            return false
        }
    }
    var userLoginState : LoginState  {
        get {
            return _userLoginState
        }
        set {
            _userLoginState = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: "userLoginState")
            print("userLoginState:\(newValue)")
            if (UIApplication.shared.applicationState == .active) {
                onApplicationActive()
            }
        }
    }
    func logoutUser() {
        
        self.pool.clearAll()
        self.pool.currentUser()?.clearSession()
        flushUserData()
    }
    
    func flushUserData() {
        userLoginState = .LoggedOut
    }
    
    @objc func onApplicationActive() {
        if userLoginState == .SessionInvalidated {
            presentSessionInvalidation()
        }
    }
    
    func presentSessionInvalidation() {
        
        let alert = UIAlertController.init(title: "Session Invalidated", message: "Your session on this device has been invalidated. Please login again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            self.logoutUser()
            (UIApplication.shared.delegate as! AppDelegate).checkLoginStatusAndNavigate()
        }))
        if var topController = UIApplication.shared.keyWindow?.rootViewController  {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true)
        }
    }
}

