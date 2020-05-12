//
//  HelpAndSupportVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 05/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class HelpAndSupportVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var subjectTextfield: UITextField!
    @IBOutlet var subjectTextField: UITextField!
    @IBOutlet var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectTextField.underLineTextField(UIColor.lightGray)
        messageTextView.underLineTextView(UIColor.lightGray)
        
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
        
        subjectTextField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.textColor == UIColor.lightGray {
            messageTextView.text = nil
            messageTextView.textColor = UIColor.black
            messageTextView.underLineTextView(UIColor.orangeColor())
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text.isEmpty {
            messageTextView.text =  "Message"
            messageTextView.textColor = UIColor.lightGray
            messageTextView.underLineTextView(UIColor.lightGray)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        subjectTextField.underLineTextField(UIColor.orangeColor())
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        subjectTextField.underLineTextField(UIColor.lightGray)
    }


}
