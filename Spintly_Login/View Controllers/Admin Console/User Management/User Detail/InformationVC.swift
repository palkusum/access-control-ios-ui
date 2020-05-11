//
//  InformationVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 22/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class InformationVC: UIViewController {

    @IBOutlet var attributeTableView: UITableView!
    @IBOutlet var attributeTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var employeeCodeTextField: UITextField!
    @IBOutlet var addedOnTextField: UITextField!
    @IBOutlet var reportingTo: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       navigationBarSetup()
       tableViewSetup()
        
        emailTextField.delegate = self
        phoneTextField.delegate = self
        employeeCodeTextField.delegate = self
        addedOnTextField.delegate = self
        reportingTo.delegate = self
        
        emailTextField.underLineTextField(UIColor.lightGray)
        phoneTextField.underLineTextField(UIColor.lightGray)
        employeeCodeTextField.underLineTextField(UIColor.lightGray)
        addedOnTextField.underLineTextField(UIColor.lightGray)
        reportingTo.underLineTextField(UIColor.lightGray)
        
        reportingTo.textFieldIcon("rightView", "downlist_arrow")
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func navigationBarSetup() {
       self.title = "Information"
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editUser))
    }
    
    func tableViewSetup() {
        attributeTableView.delegate = self
        attributeTableView.dataSource = self
        attributeTableView.tableFooterView = UIView(frame: .zero)
        attributeTableView.separatorStyle = .none
    }
    
    
    @objc func editUser() {
        
    }
}

extension InformationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AttributeTableViewCell", owner: self, options: nil)?.first as! AttributeTableViewCell
        cell.selectionStyle = .none
        cell.placeholder.text = "Department"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

extension InformationVC: UITextFieldDelegate {
    
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
