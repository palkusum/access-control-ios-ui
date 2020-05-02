//
//  PasswordVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 09/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {

    @IBOutlet var cardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

//         Do any additional setup after loading the view.
    }

    
    @IBAction func login(_ sender: UIButton) {
        self.navigationController?.pushViewController(SignupVC(), animated: true)
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(ConfirmPasswordVC(), animated: true)
    }
    
    @IBAction func loginUsingOtp(_ sender: UIButton) {
        self.navigationController?.pushViewController(OtpVC(), animated: true)
    }
}
