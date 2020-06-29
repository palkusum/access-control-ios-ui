//
//  AddUserVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 15/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import ContactsUI
import Toast_Swift

protocol UserAddListener {
    func didAddUser()
}

class AddUserStep1VC: UIViewController {

    @IBOutlet var phoneTextfield: FPNTextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var reportingTo: UITextField!
    @IBOutlet var reportingToUnderlineView: UIView!
    @IBOutlet var adminRoleCheckbox: UIButton!
    @IBOutlet var managerRoleCheckbox: UIButton!
    @IBOutlet var enableMobileRadioButton: UIButton!
    @IBOutlet var disableMobileRadioButton: UIButton!
    
    
    var isAdminChecked = false
    var isManagerChecked = false
    
    var organisationId : Int = Utils.getCurrentOrganisationDataDetails()!.id
    let addUserViewModel = AddUserViewModel()
    var delegate : UserAddListener?

    private lazy var managerPickerView : ToolbarPickerView = {
        let pickerView = ToolbarPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.toolbarDelegate = self
        return pickerView
    }()
    
    convenience init(organisationId : Int = Utils.getCurrentOrganisationDataDetails()!.id, delegate : UserAddListener? = nil) {
        self.init()
        self.organisationId = organisationId
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapToHideKeyboard()
        addUserViewModel.organisationId = organisationId
        
        addUserViewModel.saveOnSuccessCompletion = {
            self.delegate?.didAddUser()
            if let index = self.navigationController?.viewControllers.index(of: self) {
                if (index > 0) {
                    self.navigationController!.popToViewController(self.navigationController!.viewControllers[index - 1], animated: true)
                } else if ((self.navigationController?.presentingViewController) != nil){
                    self.dismiss(animated: true)
                }
            }
        }
        self.title = "Add user"

        phoneTextfield.underLineTextField(UIColor.lightGray)
        nameTextfield.underLineTextField(UIColor.lightGray)
        emailTextfield.underLineTextField(UIColor.lightGray)
        reportingTo.underLineTextField(UIColor.lightGray)
//
//        reportingTo.textFieldIcon("rightView", "downlist_arrow")
        
        
        phoneTextfield.delegate = self
        nameTextfield.delegate = self
        emailTextfield.delegate = self
        reportingTo.delegate = self
        
        reportingTo.text = "None"
        reportingTo.inputView = managerPickerView
        reportingTo.inputAccessoryView = managerPickerView.toolbar
        
        DispatchQueue.main.async { //Allow time for view to load
            self.view.activityStartAnimating(backgroundColor: .clear)
        }
        addUserViewModel.fetchFormData { (errorMessage) in
            self.view.activityStopAnimating()
            if let message = errorMessage {
                let alert = UIAlertController.init(title: "", message: message, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor());
                self.present(alert, animated: true)
            } else {
                self.navigationRefresh()
            }
        }
    }

    func navigationRefresh() {
        if addUserViewModel.barriers.count > 0 || addUserViewModel.attributeList.count > 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(validateAndNextStep))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(validateAndSave))
        }
    }
    
    @objc func validateAndNextStep(){
        if validation() {
            let addUseController = AddUserStep2VC(viewModel: addUserViewModel)
            self.navigationController?.pushViewController(addUseController, animated: true)
        }
    }
    
    @objc func validateAndSave() {
        if validation() {
            self.view.activityStartAnimating(backgroundColor: .clear)
            addUserViewModel.addUser { (errorMessage) in
                self.view.activityStopAnimating()
                if let message = errorMessage {
                    let alert = UIAlertController.init(title: "", message: message, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor());
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func openContactPicker(_ sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    @IBAction func adminRoleCheckboxButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            addUserViewModel.assignedRoles.insert(.admin)
        } else {
            addUserViewModel.assignedRoles.remove(.admin)
        }
        isAdminChecked = sender.isSelected
    }
    
    @IBAction func managerRoleCheckboxButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            addUserViewModel.assignedRoles.insert(.manager)
        } else {
            addUserViewModel.assignedRoles.remove(.manager)
        }
        isManagerChecked = sender.isSelected
    }
    
    @IBAction func enableMobileAccess(_ sender: UIButton) {
        enableMobileRadioButton.isSelected = true
        disableMobileRadioButton.isSelected = false
        addUserViewModel.mobileAccess = true
    }
    
    @IBAction func disableMobileAccess(_ sender: UIButton) {
        enableMobileRadioButton.isSelected = false
        disableMobileRadioButton.isSelected = true
        addUserViewModel.mobileAccess = false
    }
    
    func validation() -> Bool {
        self.view.endEditing(true)
        guard let number = phoneTextfield.getRawPhoneNumber() else {
            if (phoneTextfield.text == nil || phoneTextfield.text == "") {
                self.view.makeToast(UIMessages.ENTER_PHONE, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
                return false
            } else {
                self.view.makeToast(UIMessages.ENTER_VALID_LENGTH_PHONE, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
                return false
            }
        }
        addUserViewModel.phoneNumber = phoneTextfield.getFormattedPhoneNumber(format: .E164)!
        
        guard !(nameTextfield.text?.isEmpty)! else {
            self.view.makeToast(UIMessages.ENTER_FULLNAME, duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        addUserViewModel.name = nameTextfield.text!
        //TODO: email validation
        addUserViewModel.email = emailTextfield.text!
        guard let _ = addUserViewModel.mobileAccess else {
            self.view.makeToast("Set Mobile Access", duration: UIMessages.TOAST_DURATION_TIME, position: .bottom)
            return false
        }
        
        return true
    }

}


extension AddUserStep1VC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underLineTextField(UIColor.orange)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.underLineTextField(UIColor.lightGray)
    }
}

extension AddUserStep1VC: UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addUserViewModel.reportingManagers.count + 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "None"
        } else {
            return addUserViewModel.reportingManagers[row - 1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //ignore
    }
        
    func didTapDone(_ pickerView: UIPickerView) {
        self.view.endEditing(true)
            addUserViewModel.selectedReportingManagerIndex = pickerView.selectedRow(inComponent: 0) - 1
        if (addUserViewModel.selectedReportingManagerIndex == -1) {
            reportingTo.text = "None"
        } else {
            reportingTo.text = addUserViewModel.reportingManagers[addUserViewModel.selectedReportingManagerIndex].name
        }
    }
    
    func didTapCancel(_ pickerView: UIPickerView) {
        self.view.endEditing(true)
        pickerView.selectRow(addUserViewModel.selectedReportingManagerIndex + 1, inComponent: 0, animated: false)
        
    }
    
}

extension AddUserStep1VC : CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
        dismiss(animated: true)
        guard phoneNumberCount > 0 else {
            self.showAlert(title: "Invalid contact", message: "No phone number associated with the contact")
            return
        }

        if phoneNumberCount == 1 {
            setNameFromContact(name: contact.givenName + " " + contact.familyName)
            setEmailFromContact(email: contact.emailAddresses.count>0 ? contact.emailAddresses[0].value as String : "")
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
            
        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
            
            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                    alert -> Void in
                    self.setNameFromContact(name: contact.givenName + " " + contact.familyName)
                    self.setEmailFromContact(email: contact.emailAddresses.count>0 ? contact.emailAddresses[0].value as String : "")
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
                alert -> Void in
                
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setNumberFromContact(contactNumber: String) {
        let phoneUtil = NBPhoneNumberUtil()

        do {
            let number = cleanNumber(string: contactNumber)
            let parsedPhoneNumber: NBPhoneNumber = try phoneUtil.parse(number, defaultRegion: phoneTextfield.selectedCountry?.code.rawValue)
            let isValid = phoneUtil.isValidNumber(parsedPhoneNumber)
            if isValid {
                phoneTextfield.set(phoneNumber: contactNumber)
            } else {
                var message = "Selected contact does not have a valid number."
                if (!number.starts(with: "+", caseSensitive: false) && number.count == 10) {
                    message += "\nMake sure selected country is correct"
                }
                self.showAlert(title: "Invalid Contact", message: message)
            }
        } catch {
            self.showAlert(title: "Invalid Contact", message: "Selected contact does not have a valid number")
        }
        
    }
    
    private func cleanNumber(string: String) -> String {
        var allowedCharactersSet = CharacterSet.decimalDigits

        allowedCharactersSet.insert("+")

        return string.components(separatedBy: allowedCharactersSet.inverted).joined(separator: "")
    }
    
    func setEmailFromContact(email: String) {
        emailTextfield.text = email
    }
    
    func setNameFromContact(name: String) {
        nameTextfield.text = name
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
