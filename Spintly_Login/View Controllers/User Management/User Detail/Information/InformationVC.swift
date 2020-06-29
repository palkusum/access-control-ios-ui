//
//  InformationVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 22/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit
import FlagPhoneNumber

protocol UserInformationUpdatedListener {
    func didUpdateUserInformation(for userId : String)
    func didDeleteUser(for userId : String)
}

class InformationVC: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var deleteButton: UIButton!
    
    private class PersonalInfo {
        var image: String
        var placeholder: String
        var text: String
        var isEditable: Bool
        init(image: String = "", placeholder: String = "", text: String = "", isEditable: Bool = false) {
            self.image = image
            self.placeholder = placeholder
            self.text = text
            self.isEditable = isEditable
        }
    }
    
    private class CheckboxState {
        var isEnabled: Bool
        var isSelected: Bool
        var titleLabel: String
        
        init(isEnabled: Bool, isSelected: Bool, titleLabel : String) {
            self.isEnabled = isEnabled
            self.isSelected = isSelected
            self.titleLabel = titleLabel
        }
    }
    
    private enum Section : Int, CaseIterable {
        case basicInfo
        case roles
        case attributes
    }
    
    private enum BasicInfoRow : Int, CaseIterable {
        case name
        case phone
        case email
        case employeeCode
        case addedOn
        case reportingManager
    }
    
    private enum RolesRow : Int, CaseIterable {
        case admin
        case manager
        case endUser
    }
    
    var userObject: UserManagementModel!
    var organisationId = Utils.getCurrentOrganisationDataDetails()!.id
    var delegate : UserInformationUpdatedListener?
    
    private var formPhoneCountryCode : FPNCountryCode?
    private var formPhoneText : String?
    
    private var formPhoneField = PersonalInfo(image: "call_section", placeholder: "Phone")
    private var formNameField = PersonalInfo(image: "user_section", placeholder: "Name")
    private var formEmailField = PersonalInfo(image: "mail_section", placeholder: "Email address")
    private var formEmployeeCode = PersonalInfo(image: "notes_section", placeholder: "Employee code")
    private var formAddedOn = PersonalInfo(image: "calender_section", placeholder: "Added on")
    
    private var formAdminRole = CheckboxState(isEnabled: false, isSelected: false, titleLabel: "Administrator")
    private var formManagerRole = CheckboxState(isEnabled: false, isSelected: false, titleLabel: "Manager")
    private var formEndUserRole = CheckboxState(isEnabled: false, isSelected: true, titleLabel: "End User")
    
    private var selectedReportingManagerIndex : Int = 0
    private var attributesList : [AttributeModel]?
    private var attributePickerViews = [ToolbarPickerView]()
    private var selectedAttributeValueIndexes = [Int]()
    private var managerList = [UserManagementModel]()
    private lazy var managerPickerView : ToolbarPickerView = {
        let pickerView = ToolbarPickerView()
        pickerView.tag = -1
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.toolbarDelegate = self
        return pickerView
    }()
    
    private var state : FormState = .viewing
    
    enum FormState {
        case viewing
        case editing
    }
    
    convenience init(user : UserManagementModel, organisationId : Int = Utils.getCurrentOrganisationDataDetails()!.id, delegate : UserInformationUpdatedListener? = nil) {
        self.init()
        self.userObject = user
        self.organisationId = organisationId
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        tableViewSetup()
        
        setData()
        setState(.viewing)
    }
    
//    override func viewDidLayoutSubviews() {
//        self.view.frame = self.view.superview!.bounds
//    }
    
    func navigationBarSetup() {
       self.title = "Information"
    }
    
    func setState(_ state : FormState) {
        self.state = state
        switch state {
        case .viewing:
            let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editUser))
            self.navigationItem.rightBarButtonItems = [edit]
            
            formPhoneField.isEditable = false
            formNameField.isEditable = false
            formEmailField.isEditable = false
            formEmployeeCode.isEditable = false
            formAdminRole.isEnabled = false
            formManagerRole.isEnabled = false
            formEndUserRole.isEnabled = false
            deleteButton.isHidden = false
            tableView.reloadData()
            
        case .editing:
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveUser)), UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(cancelChanges))]
            
            formPhoneField.isEditable = !userObject.isSignedUp
            formNameField.isEditable = true
            formEmailField.isEditable = true
            formEmployeeCode.isEditable = true
            formAdminRole.isEnabled = true
            formManagerRole.isEnabled = true
            formEndUserRole.isEnabled = false
            
            deleteButton.isHidden = true
            tableView.reloadData()
        }
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(nibWithCellClass: PersonalInfoTableViewCell.self)
        tableView.register(nibWithCellClass: ReportingToTableViewCell.self)
        tableView.register(nibWithCellClass: RolesTableViewCell.self)
        tableView.register(nibWithCellClass: AttributeTableViewCell.self)
    }
    
    func setData() {
        formNameField.text = userObject.name
        formEmailField.text = userObject.email
        
        formPhoneField.text = userObject.phone
        
        formEmployeeCode.text = userObject.employeeCode
        formAddedOn.text = NSDate.getDateStringToFormat(inputDate: userObject.createdAt, inputFormat: DateFormats.API_DATE_FORMAT, outputFormat: "EEEE, MMMM dd, yyyy")

        let privileges = userObject.privileges.map {USER_PRIVILEGE.init(rawValue: $0)}
        formAdminRole.isSelected = privileges.contains(.admin)
        formManagerRole.isSelected = privileges.contains(.manager)
        formEndUserRole.isSelected = privileges.contains(.end_user)

        if attributesList == nil {
            attributesList = userObject.attributes
            managerList = []
            if (userObject.reportingTo != nil) {
                managerList.append(userObject.reportingTo!)
                selectedReportingManagerIndex = 1
            }
            populateAttributesTable()
            fetchFormData()
        }
    }
    
    @IBAction func onDeletePressed(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this user?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.deleteUserAPICall()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc func editUser() {
        setState(.editing)
    }
    
    @objc func saveUser() {
        
    }
    
    @objc func cancelChanges() {
        self.view.endEditing(true)
        setState(.viewing)
        setData()
    }
    
    private func fetchFormData() {
        DispatchQueue.main.async {
            self.view.activityStartAnimating(backgroundColor: .clear)
        }
        let url = "/organisations/\(organisationId)/users/new"
        APIManager.shared().getRequestWithUrl(url, method: .get, andParameters: [:]) { response in
            self.view.activityStopAnimating()
            if (response.status) {
                let message = response.object!["message"] as! [String : Any]
                let attributesJsonArray = message["attributes"] as! [[String : Any]]
                self.attributesList = attributesJsonArray.map { AttributeModel(object: $0) }
                let managersJsonArray = message["reportingManagers"] as! [[String : Any]]
                self.managerList = managersJsonArray.map { UserManagementModel(object: $0) }
                for (index, item) in self.managerList.enumerated() {
                    if (item.id == self.userObject.reportingTo?.id) {
                        self.selectedReportingManagerIndex = index + 1;
                        break
                    }
                }
                self.populateAttributesTable()
            } else {
                UIAlertController.init(title: "", message: response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor()).show()
            }
        }
    }
    
    private func deleteUserAPICall(){
        
        let dict = [String: Any]()
        let url = "organisations/\(organisationId)/users/\(userObject.id)"
        self.view.activityStartAnimating(backgroundColor: UIColor.clear)
        
        APIManager.shared().getRequestWithUrl(url, method: .delete, andParameters: dict, withCompletion: { response in
            self.view.activityStopAnimating()
            if response.status {
                let responseDic = response.object! as [String: Any]
                //print(responseDic)
                self.navigationController?.popViewController()
                self.delegate?.didDeleteUser(for: self.userObject.id)
                
                
            }else{
                UIAlertController.init(title: response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED, message: "", defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor()).show()
            }
        })
    }

    
    func populateAttributesTable() {
        guard let attributeList = attributesList, attributeList.count > 0 else {
            tableView.reloadData()
            return
        }
        print("populateAttributesTable")
        attributePickerViews = [ToolbarPickerView]()
        selectedAttributeValueIndexes = [Int](repeating: 0, count: attributeList.count)
        for (i, attribute) in attributeList.enumerated() {
            let pickerView = ToolbarPickerView()
            pickerView.tag = i + 100
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.toolbarDelegate = self
            attributePickerViews.append(pickerView)
            
            var selectedRow = 0
            for userAtt in userObject.attributes {
                if (userAtt.attributeName == attribute.attributeName) {
                    if (userAtt.values.count > 0) {
                        for (k, attValue) in attribute.values.enumerated() {
                            if attValue == userAtt.values[0] {
                                selectedRow = k + 1
                                break
                            }
                        }
                    }
                    break
                }
            }
            selectedAttributeValueIndexes[i] = selectedRow
            pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        }
        tableView.reloadData()
//        self.attributeTableView.removeConstraints(self.attributeTableView.constraints.filter {$0.firstAttribute == .height || $0.secondAttribute == .height})
//        self.attributeTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.attributeTableView.contentSize.height).isActive = true
        
    }
    
//    private func resizeTableView(_ tableView : UITableView) {
//        tableView.removeConstraints(tableView.constraints.filter {$0.firstAttribute == .height || $0.secondAttribute == .height})
//        tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: tableView.contentSize.height).isActive = true
//    }
    
}

extension InformationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .basicInfo:
            return BasicInfoRow.allCases.count
        case .roles:
            return RolesRow.allCases.count
        case .attributes:
            return attributesList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .basicInfo:
            switch BasicInfoRow.init(rawValue: indexPath.row)! {
            case .phone:
//                let cell = tableView.dequeueReusableCell(withClass: PhoneTableViewCell.self, for: indexPath)
//                if formPhoneCountryCode != nil {
//                    cell.phoneTextField.setFlag(countryCode: formPhoneCountryCode!)
//                }
//
//                if formPhoneText != nil {
//                    cell.phoneTextField.text = formPhoneText!
//                }
//                cell.isEditable = state == .editing && userObject.isSignedUp
//                return cell
                let cell = tableView.dequeueReusableCell(withClass: PersonalInfoTableViewCell.self, for: indexPath)
                cell.returnValue = { value in
                    self.formPhoneField.text = value
                }
                cell.infoImageView.image = UIImage(named: formPhoneField.image)
                cell.infoTextField.text = formPhoneField.text
                cell.infoTextField.keyboardType = .numberPad
                cell.placeholderLabel.text = formPhoneField.placeholder
                cell.isEditable = formPhoneField.isEditable
                return cell
            case .name:
                let cell = tableView.dequeueReusableCell(withClass: PersonalInfoTableViewCell.self, for: indexPath)
                cell.returnValue = { value in
                    self.formNameField.text = value
                }
                cell.infoImageView.image = UIImage(named: formNameField.image)
                cell.infoTextField.text = formNameField.text
                cell.infoTextField.keyboardType = .default
                cell.placeholderLabel.text = formNameField.placeholder
                cell.isEditable = formNameField.isEditable
                return cell
            case .email:
                let cell = tableView.dequeueReusableCell(withClass: PersonalInfoTableViewCell.self, for: indexPath)
                cell.returnValue = { value in
                    self.formEmailField.text = value
                }
                cell.infoImageView.image = UIImage(named: formEmailField.image)
                cell.infoTextField.text = formEmailField.text
                cell.infoTextField.keyboardType = .emailAddress
                cell.placeholderLabel.text = formEmailField.placeholder
                cell.isEditable = formEmailField.isEditable
                return cell
            case .employeeCode:
                let cell = tableView.dequeueReusableCell(withClass: PersonalInfoTableViewCell.self, for: indexPath)
                cell.returnValue = { value in
                    self.formEmployeeCode.text = value
                }
                cell.infoImageView.image = UIImage(named: formEmployeeCode.image)
                cell.infoTextField.text = formEmployeeCode.text
                cell.infoTextField.keyboardType = .default
                cell.placeholderLabel.text = formEmployeeCode.placeholder
                cell.isEditable = formEmployeeCode.isEditable
                return cell
            case .addedOn:
                let cell = tableView.dequeueReusableCell(withClass: PersonalInfoTableViewCell.self, for: indexPath)
                cell.returnValue = { value in
                    self.formAddedOn.text = value
                }
                cell.infoImageView.image = UIImage(named: formAddedOn.image)
                cell.infoTextField.text = formAddedOn.text
                cell.infoTextField.keyboardType = .default
                cell.placeholderLabel.text = formAddedOn.placeholder
                cell.isEditable = formAddedOn.isEditable
                return cell
            case .reportingManager:
                let cell = tableView.dequeueReusableCell(withClass: ReportingToTableViewCell.self, for: indexPath)
                if selectedReportingManagerIndex == 0 {
                    cell.reportingToTextField.text = "None"
                } else {
                    cell.reportingToTextField.text = managerList[selectedReportingManagerIndex - 1].name
                }

                cell.reportingToTextField.inputView = managerPickerView
                cell.reportingToTextField.inputAccessoryView = managerPickerView.toolbar
                cell.isEditable = state == .editing
                return cell
            }
        case .roles:
            let cell = tableView.dequeueReusableCell(withClass: RolesTableViewCell.self, for: indexPath)
            switch RolesRow(rawValue: indexPath.row)! {
            case .admin:
                cell.returnValue = { value in
                    self.formAdminRole.isSelected = value
                }
                cell.checkBox.setTitle(formAdminRole.titleLabel, for: .normal)
                cell.checkBox.isEnabled = formAdminRole.isEnabled
                cell.checkBox.isSelected = formAdminRole.isSelected
                cell.selectionStyle = .none
                return cell
            case .manager:
                cell.returnValue = { value in
                    self.formManagerRole.isSelected = value
                }
                cell.checkBox.setTitle(formManagerRole.titleLabel, for: .normal)
                cell.checkBox.isEnabled = formManagerRole.isEnabled
                cell.checkBox.isSelected = formManagerRole.isSelected
                cell.selectionStyle = .none
                return cell
            case .endUser:
                cell.returnValue = { value in
                    self.formEndUserRole.isSelected = value
                }
                cell.checkBox.setTitle(formEndUserRole.titleLabel, for: .normal)
                cell.checkBox.isEnabled = formEndUserRole.isEnabled
                cell.checkBox.isSelected = formEndUserRole.isSelected
                cell.selectionStyle = .none
                return cell
            }
        case .attributes:
            let cell = tableView.dequeueReusableCell(withClass: AttributeTableViewCell.self, for: indexPath)
            let attribute = attributesList![indexPath.row]
            let pickerView = attributePickerViews[indexPath.row]
            cell.placeholder.text = attribute.attributeName
            cell.attributeField.placeholder = attribute.attributeName
            cell.attributeField.inputView = pickerView
            cell.attributeField.inputAccessoryView = pickerView.toolbar
            let index = selectedAttributeValueIndexes[indexPath.row]
            if index > 0 {
                cell.attributeField.text = attribute.values[index - 1]
            } else {
                cell.attributeField.text = "None"
            }
            print("cell for row at called for \(indexPath.row)")
            
            cell.isEditable = state == .editing
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AttributeTableViewCell {
            cell.attributeField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == Section.roles.rawValue) {
            return "Roles"
        } else if (section == Section.attributes.rawValue) {
            return "Attributes"
        } else if (section == Section.basicInfo.rawValue){
            return "Basic Info"
        }
        return nil
    }

}

extension InformationVC: UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == -1) {
            return managerList.count + 1
        }
        return attributesList![pickerView.tag - 100].values.count + 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "None"
        } else if (pickerView.tag == -1) {
            return managerList[row - 1].name
        } else {
            let attribute = attributesList![pickerView.tag - 100]
            return attribute.values[row - 1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //ignore
    }
        
    func didTapDone(_ pickerView: UIPickerView) {
        self.view.endEditing(true)
        if (pickerView.tag == -1) {
            selectedReportingManagerIndex = pickerView.selectedRow(inComponent: 0)
            tableView.reloadRows(at: [IndexPath.init(item: BasicInfoRow.reportingManager.rawValue, section: Section.basicInfo.rawValue)], with: .automatic)
        } else {
            let index = pickerView.tag - 100
            selectedAttributeValueIndexes[index] = pickerView.selectedRow(inComponent: 0)
            tableView.reloadRows(at: [IndexPath(item: index, section: Section.attributes.rawValue)], with: .automatic)
        }
    }
    
    func didTapCancel(_ pickerView: UIPickerView) {
        self.view.endEditing(true)
        if (pickerView.tag == -1) {
            pickerView.selectRow(selectedReportingManagerIndex, inComponent: 0, animated: false)
        } else {
            pickerView.selectRow(selectedAttributeValueIndexes[pickerView.tag - 100], inComponent: 0, animated : false)
        }
    }
    
}
