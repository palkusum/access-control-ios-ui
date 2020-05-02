//
//  LoginVc.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 22/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

   
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOpacity = 0.2
//        cardView.layer.shadowOffset = .zero

    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        print("Button clicked")
        self.navigationController?.pushViewController(PasswordVC(), animated: true)
    }
}
