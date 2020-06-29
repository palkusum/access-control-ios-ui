//
//  ReportingToTableViewCell.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 05/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class ReportingToTableViewCell: UITableViewCell, UITextFieldDelegate {

   
    @IBOutlet var reportingToTextField: UITextField!
       @IBOutlet var underline: UIView!
       @IBOutlet var arrow: UIButton!
       
       var isEditable: Bool = false {
           didSet {
               reportingToTextField.isEnabled = isEditable
               underline.isHidden = !isEditable
               arrow.isHidden = !isEditable
           }
       }
           
       override func awakeFromNib() {
           super.awakeFromNib()
           reportingToTextField.delegate = self
       }
       
       @IBAction func onArrowClicked(_ sender: UIButton) {
           reportingToTextField.becomeFirstResponder()
       }
       
       func textFieldDidBeginEditing(_ textField: UITextField) {
           underline.backgroundColor = .orange

       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           underline.backgroundColor = .lightGray

       }
    
}
