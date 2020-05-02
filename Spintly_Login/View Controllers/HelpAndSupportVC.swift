//
//  HelpAndSupportVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 05/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


class HelpAndSupportVC: UIViewController {

    @IBOutlet weak var subjectTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        subjectTextfield.setPadding()
//        subjectTextfield.setBottomBorder()

    }


}
