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
    
    var activeTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        phoneTextfield.underLineTextField()
        nameTextfield.underLineTextField()
        emailTextfield.underLineTextField()
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
        activeTextfield = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
