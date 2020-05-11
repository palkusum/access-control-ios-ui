//
//  AddUserVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 15/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AddUserStep1VC: UIViewController {

    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var reportingTo: UITextField!
    @IBOutlet var reportingToUnderlineView: UIView!
    
    var activeTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        phoneTextfield.underLineTextField(UIColor.lightGray)
        nameTextfield.underLineTextField(UIColor.lightGray)
        emailTextfield.underLineTextField(UIColor.lightGray)
        reportingTo.underLineTextField(UIColor.lightGray)
        
        reportingTo.textFieldIcon("rightView", "downlist_arrow")
        
        
        phoneTextfield.delegate = self
        nameTextfield.delegate = self
        emailTextfield.delegate = self
        reportingTo.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = view.superview!.bounds
    }
    
    
    
    
    func navigationBarSetup() {
        self.title = "Add user"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
    }
    
    @objc func nextStep(){
         let addUseController = AddUserStep2VC()
         self.navigationController?.pushViewController(addUseController, animated: true)
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
