//
//  InformationVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 22/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//


import UIKit


struct PersonalInfo {
    var image: String!
    var placeholder: String!
    var textField: String!
}


class InformationVC: UIViewController {

    @IBOutlet var attributeTableView: UITableView!
    @IBOutlet var attributeTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var employeeCodeTextField: UITextField!
    @IBOutlet var addedOnTextField: UITextField!
    @IBOutlet var reportingTo: UITextField!
    @IBOutlet var informationTableView: UITableView!
    
    var infoList = [PersonalInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoList = [PersonalInfo(image: "mail_section", placeholder: "Email address", textField: "sneha@mrinq.com"), PersonalInfo(image: "notes_section", placeholder: "Employee code", textField: "1007"), PersonalInfo(image: "calender_section", placeholder: "Added on",  textField: "Janyuary 07, 2019") ]

       navigationBarSetup()
       tableViewSetup()
        
//        emailTextField.delegate = self
//        phoneTextField.delegate = self
//        employeeCodeTextField.delegate = self
//        addedOnTextField.delegate = self
//        reportingTo.delegate = self
//
//        emailTextField.underLineTextField(UIColor.lightGray)
//        phoneTextField.underLineTextField(UIColor.lightGray)
//        employeeCodeTextField.underLineTextField(UIColor.lightGray)
//        addedOnTextField.underLineTextField(UIColor.lightGray)
//        reportingTo.underLineTextField(UIColor.lightGray)
//
//        reportingTo.textFieldIcon("rightView", "downlist_arrow")
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func navigationBarSetup() {
       self.title = "Information"
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editUser))
    }
    
    func tableViewSetup() {
        informationTableView.delegate = self
        informationTableView.dataSource = self
        informationTableView.tableFooterView = UIView(frame: .zero)
        informationTableView.separatorStyle = .none
    }
    
    
    @objc func editUser() {
        
    }
}

extension InformationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if section == 1 {
            return 3
        } else if section == 4 {
            return 4
       } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("PhoneTableViewCell", owner: self, options: nil)?.first as! PhoneTableViewCell
//          cell.phoneTextField.text = "+991345657675"
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.section == 1 {
            let cell = Bundle.main.loadNibNamed("PersonalInfoTableViewCell", owner: self, options: nil)?.first as! PersonalInfoTableViewCell
            cell.infoImageView.image = UIImage(named: infoList[indexPath.row].image)
            cell.placeholderLabel.text = infoList[indexPath.row].placeholder
            cell.textField.text = infoList[indexPath.row].textField
            if indexPath.row == 0 {
                cell.imageViewHeightConstraint.constant = 30
                cell.imageViewWidthConstraint.constant = 30
            }
            cell.selectionStyle = .none
            return cell
            
         } else if indexPath.section == 2 {
            let cell = Bundle.main.loadNibNamed("ReportingToTableViewCell", owner: self, options: nil)?.first as! ReportingToTableViewCell
           cell.reportingToTextField.text = "Manager 1"
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.section == 3 {
            let cell = Bundle.main.loadNibNamed("RolesTableViewCell", owner: self, options: nil)?.first as! RolesTableViewCell
//           cell.adminCheckboxButton.titleLabel?.text = ""
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = Bundle.main.loadNibNamed("AttributeTableViewCell", owner: self, options: nil)?.first as! AttributeTableViewCell
            cell.selectionStyle = .none
            cell.placeholder.text = "Department"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 220
        } else if indexPath.section == 4 {
            return 60
        } else {
            return 80
        }
    }
    
    
}

extension InformationVC: UITextFieldDelegate {
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.underLineTextField(UIColor.orange)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.underLineTextField(UIColor.lightGray)
//    }
}
