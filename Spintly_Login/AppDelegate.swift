//
//  AppDelegate.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 09/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AWSCore
import AWSCognitoIdentityProvider
import UserNotifications
import AWSSNS
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?
     public var navController: UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        checkLoginStatusAndNavigate()

        IQKeyboardManager.shared.enable = true
        
        RealmConfiguration.setupConfiguration()
        self.awsCognitoSetup()
        registerForPushNotifications(application: application)
        
//        let mainVc = MainVC()
//        let nav = UINavigationController(rootViewController: mainVc)
//        let navigationBarAppearace = UINavigationBar.appearance()
//        navigationBarAppearace.tintColor = .white
//        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        navigationBarAppearace.barTintColor = .myColor()
//        window?.rootViewController = nav
//        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        
        return true
    }
    
    //MARK:- AWS Cognito
       
   func awsCognitoSetup() {
       
       // setup service configuration
       let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
       
       // create pool configuration
       let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,clientSecret: nil,poolId: CognitoUserPoolId)
       
       // initialize user pool client
       AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
       
       // fetch the user pool client we initialized in above step
       let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)

       let credentialsProvider = AWSCognitoCredentialsProvider(
           regionType: CognitoIdentityUserPoolRegion, identityPoolId: CognitoIdentityUserPoolId)
       let defaultServiceConfiguration = AWSServiceConfiguration(
           region: CognitoIdentityUserPoolRegion, credentialsProvider: credentialsProvider)
       AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
       
   }

   func checkLoginStatusAndNavigate() {
        let rootViewController: UIViewController;
        if (!UserManager.shared().isLoggedIn()) {
            rootViewController = EnterPhoneVC()
        } else {
            rootViewController = MainVC()
        }
        navController = UINavigationController(rootViewController: rootViewController)
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearace.barTintColor = UIColor.primaryColor()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()

        let searchBarAppearance = UISearchBar.appearance()
        searchBarAppearance.barTintColor = navigationBarAppearace.barTintColor
        searchBarAppearance.tintColor = navigationBarAppearace.tintColor
        searchBarAppearance.backgroundColor = searchBarAppearance.barTintColor
        searchBarAppearance.barStyle = .default
        searchBarAppearance.searchBarStyle = .minimal
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = navigationBarAppearace.titleTextAttributes ?? UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        }


    func registerForPushNotifications(application: UIApplication) {
        /// The notifications settings
        application.registerForRemoteNotifications()
    }


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Attach the device token to the user defaults
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceTokenForSNS")

        NotificationCenter.default.post(name: Notification.Name.REGISTER_REMOTE_NOTIFICATION_STATUS, object: nil, userInfo:
            [
                "isSuccess" : true,
                "token" : token
            ]
        )

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print(error.localizedDescription)
        NotificationCenter.default.post(name: Notification.Name.REGISTER_REMOTE_NOTIFICATION_STATUS, object: nil, userInfo:
            [
                "isSuccess" : false,
                "error" : error
            ]
        )
    }


    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            //print("User Info = \(userInfo)")
            
        if UserManager.shared().isLoggedIn() {
            
            let dataDict =  userInfo["data"] as? [String:Any]
            let changedForDict = dataDict?["changedFor"] as? [String:Any]
            
            
            dump(dataDict)
            guard let dataType = PUSHNOTIFICATION_TYPE(rawValue: dataDict?["type"] as? String ?? "") else {
                print("unknown data type")
                return
            }
            
            switch dataType {
                
            case PUSHNOTIFICATION_TYPE.ACCESS_CHANGE_NOTIF:
                print(PUSHNOTIFICATION_TYPE.ACCESS_CHANGE_NOTIF)
                self.getUserPermissionListAPICall(organisationId: changedForDict!["organisation_id"] as! Int)
                break
                
            case PUSHNOTIFICATION_TYPE.REMOVE_ORG_NOTIF:
                print(PUSHNOTIFICATION_TYPE.REMOVE_ORG_NOTIF)
                self.removeTheOrganisation(organisationId: changedForDict!["organisation_id"] as! Int)
                break
                
            case PUSHNOTIFICATION_TYPE.UPDATE_ORG_USER_DATA:
                print(PUSHNOTIFICATION_TYPE.UPDATE_ORG_USER_DATA)
                self.getUserPermissionListAPICall(organisationId: changedForDict!["organisation_id"] as! Int)
//                self.updateTheOrganisationRole(organisationId: changedForDict!["organisation_id"] as! Int, newRole: changedForDict!["role"] as! String)
                break
                
            case PUSHNOTIFICATION_TYPE.REMOTE_UNLOCK_ACK:
                NotificationCenter.default.post(name: Notification.Name.REMOTE_UNLOCK_ACK, object: nil, userInfo: dataDict)
                break
                
            case PUSHNOTIFICATION_TYPE.USER_FORCE_SIGNOUT:
                if (UserManager.shared().userLoginState != .LoggedOut) {
                    UserManager.shared().userLoginState = .SessionInvalidated
                }
            default:
                break
            }
        }
            
    }

    func getUserPermissionListAPICall(organisationId: Int) {
            
        var dict = [String: Any]()
        dict["organisation_id"] = organisationId
        dict["deviceUUID"] = PhoneDataManager.shared.getUniqueDeviceId()
        
        APIManager.shared().requestWithJson(API_END_POINTS.USERS_PERMISSION_LIST , method: .post, andParameters: dict, withCompletion: { response in
            
            if response.status {
                let responseDic = response.object! as [String: Any]
                let orgDict = responseDic["message"] as! [String:Any]
                let organisationsArray = orgDict["organisations"] as! [[String:Any]]
//                let organisationUpdatedDic = organisationsArray[0]
                //print(responseDic["message"] as Any)
                
                for orgDic in organisationsArray {
                    self.insertOrUpdateOrganisation(organisationDictionary: orgDic)
                }

            } else if (response.statusCode == 401) {
                if UserManager.shared().userLoginState == .LoggedIn {
                    UserManager.shared().userLoginState = .SessionInvalidated
                }
            }
        })
    }
    
    func removeTheOrganisation(organisationId: Int) {
        
        var OrgIndex = 0
        let currentOrganisationObjectBeforeDelete = Utils.getCurrentOrganisationDataDetails()
        var organisationObjectsArray = Utils.getOrganisationDetailsDict()

        for dic in organisationObjectsArray {
            
            if dic["id"] as! Int == organisationId {
                organisationObjectsArray.remove(at: OrgIndex)
            }
            
            OrgIndex = OrgIndex + 1
        }
        
        if organisationObjectsArray.count == 0 {
            // If no current organisation is there then set the default organisation
            let emptyPermissionArray : [AnyObject] = []
            let dummyOrganisationObject = ["id": -1, "location": "", "name": "Spintly Smart Access", "permissions":emptyPermissionArray, "type":"", "userRole":"end_user"] as [String : Any]
            var defaultDummyOrganisationForNewUser = [[String : Any]]()
            defaultDummyOrganisationForNewUser.append(dummyOrganisationObject)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: defaultDummyOrganisationForNewUser)
            UserManager.shared().setOrganisationDicData(organisationsDic: encodedData)
            UserManager.shared().setCurrentOrganisation(id: -1)
            
        }else{
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: organisationObjectsArray)
            UserManager.shared().setOrganisationDicData(organisationsDic: encodedData)
            
            // IF DELETED ORGANISATION IS CURRENT ORGANISTION THEN SET-CURRENT ORGANISATION
            if organisationId == currentOrganisationObjectBeforeDelete?.id {
                let currentOrgDic = organisationObjectsArray[0] // set 0 th organisation as default orgnisation
                UserManager.shared().setCurrentOrganisation(id: currentOrgDic["id"] as! Int)
            }
        }
        
    }
    
    func insertOrUpdateOrganisation(organisationDictionary: [String : Any]) {
        var organisationsDict = Utils.getOrganisationDetailsDict()
        var updateAtIndex = -1
        for (index, orgDic) in organisationsDict.enumerated() {
            if (orgDic["id"] as! Int == organisationDictionary["id"] as! Int) {
                updateAtIndex = index
                break
            }
        }
        if updateAtIndex < 0 {
            organisationsDict.append(organisationDictionary)
        } else {
            organisationsDict[updateAtIndex] = organisationDictionary
        }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: organisationsDict)
        UserDefaults.standard.set(encodedData, forKey: "organisationsDic")
        
        let currentOrganisation = Utils.getCurrentOrganisationDataDetails()
        if currentOrganisation?.id == -1 {
           self.removeTheOrganisation(organisationId: -1)
        } else if organisationDictionary["id"] as! Int == currentOrganisation?.id {
            UserManager.shared().setCurrentOrganisation(id: currentOrganisation!.id)
        }
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("User Info = “,notification.request.content.userInfo")
        completionHandler([.alert, .badge, .sound])
    }
    
    // Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //print("User Info = “,response.notification.request.content.userInfo")
        completionHandler()
    }
    
}


