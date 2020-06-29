//
//  LoginVc.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 22/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class EnterPhoneVC: UIViewController {

   
    @IBOutlet var phoneTextField: FPNTextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountryCodePicker()
        setExistingNumber()
        tapToHideKeyboard()

    }
    
    func setupCountryCodePicker() {
           phoneTextField.displayMode = .list // .picker by default
           phoneTextField.delegate = self
    }
       
   func setExistingNumber() {
       print("username:\(String(describing: AWSCredentialsManager.shared.currentUser?.username))")
       phoneTextField.set(phoneNumber: AWSCredentialsManager.shared.currentUser?.username ?? "")
   }

    @IBAction func nextButton(_ sender: UIButton) {
        print("Next Button clicked")
        guard let _ = phoneTextField.getRawPhoneNumber() else {
            let message : String
            if (phoneTextField.text == nil || phoneTextField.text == "") {
                message = UIMessages.ENTER_PHONE
            } else {
                message = UIMessages.ENTER_VALID_LENGTH_PHONE
            }
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            present(alert, animated: true)
            return
        }
        let number = phoneTextField.getFormattedPhoneNumber(format: .E164)!
           print("number: \(number)")
           let alertController = UIAlertController(title: "Please wait", message: "Checking phone number..", preferredStyle: .alert)
           self.present(alertController, animated: true)
        AWSCredentialsManager.shared.checkIfUserSignedUp(number) { isSignedUp, error in
            alertController.dismiss(animated: true) {
                if let isSignedUp = isSignedUp {
                    let nextView : UIViewController
                    if (isSignedUp) {
                        let pvc = PasswordVC()
                        pvc.phoneNumber = number
                        nextView = pvc
                    } else {
                        let svc = SignupVC()
                        svc.phoneNumber = number
                        nextView = svc
                    }
                    self.navigationController?.pushViewController(nextView, animated: true)
                } else if let error = error as NSError? {
//                    let alert = UIAlertController(title: "Error", message: error.localizedDescription)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
//        self.navigationController?.pushViewController(PasswordVC(), animated: true)

    }
}

extension EnterPhoneVC: FPNTextFieldDelegate {
    
    func fpnDisplayCountryList() {
        let countryListViewController = FPNCountryListViewController(style: .grouped)

        countryListViewController.setup(repository: phoneTextField.countryRepository)
        countryListViewController.didSelect = { [weak self] country in
            self?.phoneTextField.setFlag(countryCode: country.code)
        }
        countryListViewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(fpnDismissCountryList))
        countryListViewController.title = "Select country"
        
        let navigationViewController = UINavigationController(rootViewController: countryListViewController)
        self.present(navigationViewController, animated: true)
    }
    
    @objc func fpnDismissCountryList() {
        presentedViewController?.dismiss(animated: true)
    }
    
    func didSelectCountry(name: String, dialCode: String, code: String) {
    
    }
    
    func didValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        //print(name, dialCode, code)
    }
}
