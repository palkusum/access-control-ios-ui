//
//  SignUpVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 24/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//
import UIKit
import AWSCognitoIdentityProvider
import FlagPhoneNumber

class SignupVC: UIViewController {
    
    var phoneNumber : String?
    
    @IBOutlet weak var phoneTextField: FPNTextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var termsPolicyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Signup"
        tapToHideKeyboard()
        setupTermsAndPolicy()
        if let phoneNumber = phoneNumber {
            phoneTextField.set(phoneNumber: phoneNumber)
            phoneTextField.isEnabled = false
        }
    }
    
    @IBAction func signupButtonPress(_ sender: Any) {
        if validateSignUpCreds() {
            let alertController = UIAlertController(title: "Please wait", message: "Signing up..", preferredStyle: .alert)
            self.present(alertController, animated: true)
            let userNameValue = NSUUID().uuidString.lowercased()
            let passwordValue = self.passwordTextField.text
            
            var attributes = [AWSCognitoIdentityUserAttributeType]()
            
            let phone = AWSCognitoIdentityUserAttributeType()
            phone?.name = "phone_number"
            phone?.value = phoneTextField.getFormattedPhoneNumber(format: .E164)!
            attributes.append(phone!)

            
            if let emailValue = self.emailTextField.text, !emailValue.isEmpty {
                let email = AWSCognitoIdentityUserAttributeType()
                email?.name = "email"
                email?.value = emailValue
                attributes.append(email!)
            }
            
            if let fullNameValue = self.nameTextField.text, !fullNameValue.isEmpty {
                let fullName = AWSCognitoIdentityUserAttributeType()
                fullName?.name = "given_name"
                fullName?.value = fullNameValue
                attributes.append(fullName!)
            }

            //sign up the user
            AWSCredentialsManager.shared.userPool.signUp(userNameValue, password: passwordValue!, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
                guard let strongSelf = self else { return nil }
                DispatchQueue.main.async(execute: {
                    alertController.dismiss(animated: true) {
                        
                        if let error = task.error as NSError? {
                            let message = error.userInfo["message"] as? String ?? error.localizedDescription
                            let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                            strongSelf.present(errorAlert, animated: true)
                        } else if let result = task.result  {
                            // handle the case where user has to confirm his identity via email / SMS
                            if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                                
                                let otpViewController = OtpVC()
                                otpViewController.destination = phone!.value!
                                otpViewController.timeoutInSeconds = 60
                                
                                class OTPRequestDelegateIMPL : OTPRequestDelegate {
                                    
                                    private let user : AWSCognitoIdentityUser
                                    private let phone : String
                                    private let password : String
                                    private let currentController : SignupVC
                                    init(user : AWSCognitoIdentityUser, phone: String, password : String, currentController : SignupVC) {
                                        self.user = user
                                        self.phone = phone
                                        self.password = password
                                        self.currentController = currentController
                                    }
                                    func didEnterOTP(_ otp: String, completion: @escaping (Error?) -> ()) {
                                        self.user.confirmSignUp(otp).continueWith { task -> Any? in
                                            DispatchQueue.main.async {
                                                completion(task.error)
                                                if task.error == nil {
                                                    self.currentController.autoLogin(phone: self.phone, password: self.password)
                                                }
                                            }
                                            return nil
                                        }
                                    }
                                    
                                    func didRequestResend(completion: @escaping (Error?) -> ()) {
                                        self.user.resendConfirmationCode().continueWith { task -> Any? in
                                            DispatchQueue.main.async {
                                                completion(task.error)
                                            }
                                            return nil
                                        }
                                    }
                                }
                                otpViewController.delegate = OTPRequestDelegateIMPL(user: result.user, phone: (phone?.value)!, password: passwordValue!, currentController: strongSelf)
                                strongSelf.navigationController?.pushViewController(otpViewController)
                            } else {
                                self?.autoLogin(phone: phone!.value!, password: passwordValue!)
                            }
                        }
                    }
                })
                return nil
            }
        
        }

    }
    
    private func autoLogin(phone: String, password: String) {

        let passwordVC = PasswordVC()
        passwordVC.phoneNumber = phone
        passwordVC.loginWithPassword = password
        
        var stack = self.navigationController?.viewControllers
        stack?.forEach({ (viewController) in
            if !(viewController is EnterPhoneVC) {
                stack?.removeAll(viewController)
            }
        })
        stack?.append(passwordVC)
        self.navigationController?.setViewControllers(stack!, animated: true)
        
    }
    
    private func setupTermsAndPolicy() {
        let text = "By signing up you agree to the Terms and Conditions and have read the Privacy Policy"
//        termsPolicyTextView.text = text
        
        let underlineAttriString = NSMutableAttributedString.init( attributedString: termsPolicyTextView.attributedText)
        let range1 = (text as NSString).range(of: "Terms and Conditions")
        let range2 = (text as NSString).range(of: "Privacy Policy")

        
//        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.link, value: URL(string: TERMS_URL)!, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        
        underlineAttriString.addAttribute(NSAttributedString.Key.link, value: URL(string: PRIVACY_URL)!, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        
        termsPolicyTextView.attributedText = underlineAttriString
//        termsPolicyTextView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
//        termsPolicyLabel.addGestureRecognizer(tap)
    }
    
    func validateSignUpCreds() -> Bool{
        
        guard let _ = phoneTextField.getRawPhoneNumber() else {
            let message : String
            if (phoneTextField.text == nil || phoneTextField.text == "") {
                message = UIMessages.ENTER_PHONE
            } else {
                message = UIMessages.ENTER_VALID_LENGTH_PHONE
            }
            self.view.makeToast(message, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        guard !(nameTextField.text?.isEmpty)! else {
            
            self.view.makeToast(UIMessages.ENTER_FULLNAME, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        guard !(emailTextField.text?.isEmpty)! else {
            
            self.view.makeToast(UIMessages.ENTER_EMAIL, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        guard !(passwordTextField.text?.isEmpty)! else {
            
            self.view.makeToast(UIMessages.ENTER_PASSWORD, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        guard ((passwordTextField.text?.count)! >= UIValidations.PASSWORD_MAX_LENGTH) else {
            
            self.view.makeToast(UIMessages.ENTER_PASSWORD_LENGTH, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        guard !(confirmPasswordTextField.text?.isEmpty)! else {
            
            self.view.makeToast(UIMessages.ENTER_CONFIRM_PASSWORD, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        guard ((confirmPasswordTextField.text?.count)! >= UIValidations.PASSWORD_MAX_LENGTH) else {
            
            self.view.makeToast(UIMessages.ENTER_PASSWORD_LENGTH, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        guard (confirmPasswordTextField.text == passwordTextField.text) else {
            
            self.view.makeToast(UIMessages.PASSOWRD_CONFIRMPASS_NOT_MATCH, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        return true
    }

}

