//
//  PasswordVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 09/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit
import AWSSNS
import AWSCognitoIdentityProvider
import RealmSwift

class PasswordVC: UIViewController {
    
     @IBOutlet weak var passwordField: UITextField!
     var phoneNumber : String!
    
    var loginWithPassword : String?
       
       var user : AWSCognitoIdentityUser?
       var otpContinuation : AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>?
       var otpResponse : ((Error?) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        tapToHideKeyboard()
        if let password = loginWithPassword {
            passwordField.text = password
            loginWithPassword(phoneNumber, password)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
          otpResponse = nil
      }

    
    @IBAction func login(_ sender: UIButton) {
     if passwordField.text?.isEmpty ?? true {
       let errorAlert = UIAlertController(title: "Error", message: "Enter Password", preferredStyle: .alert)
       errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
       self.present(errorAlert, animated: true)
       } else {
           loginWithPassword(phoneNumber, passwordField.text!)
       }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let vc = ConfirmPasswordVC()
        vc.phoneNumber = phoneNumber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginUsingOtp(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Please wait", message: "Requesting OTP...", preferredStyle: .alert)
        self.present(alertController, animated: true, overwrite: true)
        
        requestOTP(phoneNumber) { error in
            if let error = error as NSError? {
                if (self.navigationController?.topViewController is PasswordVC) {
                    let errorAlert = UIAlertController(title: "Error", message: error.userInfo["message"] as? String ?? error.localizedDescription, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(errorAlert, animated: true, overwrite: true)
                }
            }
        }
    }
    
    func loginWithPassword(_ username: String, _ password: String) {
        let alertController = UIAlertController(title: "Please wait", message: "Logging in..", preferredStyle: .alert)
        self.present(alertController, animated: true)
        AWSCredentialsManager.shared.userPool.getUser(username)
            .getSession(username, password: password, validationData: nil)
            .continueWith { task -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error as NSError? {
                        print (error)
                        alertController.dismiss(animated: true) {
                            let message = error.userInfo["message"] as? String ?? error.localizedDescription
                            let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.present(errorAlert, animated: true)
                        }
                    } else {
                        self.onLoginComplete()
                    }
                }
                return nil
        }
    }
    
    func onLoginComplete() {
        let alertController = UIAlertController(title: "Please wait", message: "Fetching Data..", preferredStyle: .alert)
        self.present(alertController, animated: true, overwrite: true)
        self.registerDevice() { errorMessage in
            if let message = errorMessage {
                let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(errorAlert, animated: true, overwrite: true)
            } else {
                alertController.dismiss(animated: true) {
                    print("going to main")
                    (UIApplication.shared.delegate as! AppDelegate).checkLoginStatusAndNavigate()
                }
            }
        }
    }
    
    func requestOTP(_ username: String, completion: @escaping (Error?)->()) {
        if (user == nil) {
            user = AWSCredentialsManager.shared.userPool.getUser(username)
        }
        user?.signOut()
        AWSCredentialsManager.shared.userPool.delegate = CustomAuthIMPL(listener: { (customAuthCompletionSource, error) in
            self.otpContinuation = customAuthCompletionSource
            completion(error)
            if (customAuthCompletionSource != nil) {
                if self.navigationController?.topViewController is OtpVC {
                    return
                }
                let otpVC = OtpVC()
                otpVC.destination = self.user!.username!
                otpVC.isSingleAttempt = true
                otpVC.resendWillInvalidateOTP = true
                otpVC.timeoutInSeconds = 60
                otpVC.delegate = self
                let closure = {
                    self.navigationController!.pushViewController(otpVC, animated: true)
                }
                if self.presentedViewController?.dismiss(animated: true, completion: closure) == nil {
                    closure()
                }
            } else if self.navigationController?.topViewController is OtpVC {
                self.otpResponse?(error)
            }
        })
        self.user?.getSession().continueWith { (task) -> Any? in
            AWSCredentialsManager.shared.resetUserPoolDelegate()
            DispatchQueue.main.async {
                if (task.error == nil) {
                    let closure = {
                        if (self.navigationController?.topViewController is OtpVC) {
                            self.navigationController?.popViewController(animated: true) {
                                self.onLoginComplete()
                            }
                        } else {
                            self.onLoginComplete()
                        }
                    }
                    if (self.navigationController?.topViewController?.presentedViewController?.dismiss(animated: false, completion: closure) == nil) {
                        closure()
                    }
                } else {
                    print("Session failed")
                    self.otpResponse?(task.error)
                }
            }
            return nil
        }
    }
    
    func generateAWSARN(completion: @escaping (_ endpoint : String?, _ errorMessage : String?)->Void) {
        #if targetEnvironment(simulator)
        completion("simulator", nil)
        return
        #endif
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoIdentityUserPoolRegion, identityPoolId: CognitoIdentityUserPoolId, identityProviderManager: AWSCredentialsManager.shared.userPool)
        let configuration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: credentialsProvider)
        AWSSNS.register(with: configuration!, forKey: "APSouth1SNS")
        /// Create a platform endpoint. In this case, the endpoint is a device endpoint ARN
        
        let sns = AWSSNS(forKey: "APSouth1SNS")
        let request = AWSSNSCreatePlatformEndpointInput()

        guard let token = UserDefaults.standard.object(forKey: "deviceTokenForSNS") as? String else {
            completion(nil, "Notifications are disabled! They are required to synchronise data")
            return
        }
        
        request?.token = token

        request?.platformApplicationArn = SNSPlatformApplicationArn

        sns.createPlatformEndpoint(request!).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask!) -> AnyObject? in
            if let error = task.error as NSError? {
                let message = error.userInfo["message"] as? String ?? error.localizedDescription
                completion(nil, message)
            } else {
                let createEndpointResponse = task.result! as AWSSNSCreateEndpointResponse
                if let endpointArnForSNS = createEndpointResponse.endpointArn {
                    completion(endpointArnForSNS, nil)
                }
            }
            return nil
        })
    }
    
    func registerDevice(completion: @escaping (_ errorMessage : String?)->Void) {
        
        self.generateAWSARN { snsEndpoint, errorMessage in
            guard let _ = snsEndpoint else {
                completion(errorMessage)
                return
            }
            UserDefaults.standard.set(snsEndpoint, forKey: "endpointArnForSNS")
            var dict = [String: Any]()
            dict["client"] = "mobile"
            dict["endpointARN"] = snsEndpoint
            dict["appVersion"] = Bundle.main.versionNumber
            dict["appPlatform"] = "iOS"
            dict["appNotifParserVersion"] = "1"
            dict["deviceUUID"] = PhoneDataManager.shared.getUniqueDeviceId()

            do {
                let jsonData = try JSONEncoder().encode(iPhoneData.getCurrentDeviceDetails())
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
                
                dict["deviceData"] = jsonDict
            } catch {
                
            }

            APIManager.shared().postRequestWithJsonUrl("v1/users/mobileDevice" , method: .post, andParameters: dict, withCompletion: { response in
        
                DispatchQueue.main.async {
                    if response.status {
                        let responseDic = response.object! as [String: Any]
                        //print(responseDic["message"] as Any)
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
                        PhoneDataManager.shared.saveCurrentPhoneData()
                        UserManager.shared().userLoginState = .LoggedIn
                        userOrganisations.forEach { (organisationDic) in
                            if let lastAttRecord = organisationDic["latestAttendanceRecord"] as? [String : Any]{
                                if let realm = try? Realm() {
                                    try? realm.write {
                                        realm.create(LastAttendanceStatusModel.self,
                                        value: [
                                            "organisationId" : organisationDic["id"] as! Int,
                                            "forDate": NSDate.getDateFromString(date: lastAttRecord["forDate"] as! String, inputFormat: DateFormats.API_DATE_FORMAT) ?? Date() ,
                                            "currentStatus": lastAttRecord["currentStatus"] as! String
                                            ],
                                        update: .modified)
                                    }
                                }
                            }
                        }
                        
                        
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
                        completion(nil)
                    }else{
                        completion(response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED)
                    }
                }
               
            })
        }
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil, overwrite: Bool = false) {
           if let vc = self.presentedViewController, overwrite {
               vc.dismiss(animated: flag) {
                   super.present(viewControllerToPresent, animated: flag, completion: completion)
               }
           } else {
               super.present(viewControllerToPresent, animated: flag, completion: completion)
           }
           
       }
}


fileprivate class CustomAuthIMPL: NSObject, AWSCognitoIdentityInteractiveAuthenticationDelegate, AWSCognitoIdentityCustomAuthentication {
    
    var isValid = true
    let onOtpReceivedListener : (AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>?, Error?)->()
    init(listener : @escaping (AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>?, Error?)->()) {
        self.onOtpReceivedListener = listener
        super.init()
    }
    
    func startCustomAuthentication() -> AWSCognitoIdentityCustomAuthentication {
        print("startCustomAuth")
        return self
    }
    
    func getCustomChallengeDetails(_ authenticationInput: AWSCognitoIdentityCustomAuthenticationInput, customAuthCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>) {
        print("challengeparams=\(authenticationInput.challengeParameters)")
        if(authenticationInput.challengeParameters.count == 0) {
            if (!isValid) {
                return
            }
            customAuthCompletionSource.set(result: AWSCognitoIdentityCustomChallengeDetails())
        } else {
            DispatchQueue.main.async {
                self.onOtpReceivedListener(customAuthCompletionSource, nil)
            }
        }
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                self.isValid = false //prevent retry infinite loop
                self.onOtpReceivedListener(nil, error)
            }
        }
    }
}

extension PasswordVC : OTPRequestDelegate {
    
    func didEnterOTP(_ otp: String, completion: @escaping (Error?) -> ()) {
        otpResponse = completion
        self.otpContinuation?.set(result: AWSCognitoIdentityCustomChallengeDetails.init(challengeResponses: [
            "USERNAME" : self.user!.username!,
            "ANSWER" : otp
        ]))
    }
    
    func didRequestResend(completion: @escaping (Error?) -> ()) {
        self.requestOTP(self.user!.username!, completion: completion)
    }
}

