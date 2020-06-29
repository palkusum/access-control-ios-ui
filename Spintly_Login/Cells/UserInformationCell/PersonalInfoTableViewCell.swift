//
//  PersonalInfoTableViewCell.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 05/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class PersonalInfoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var infoImageView: UIImageView!
    
    @IBOutlet var placeholderLabel: UILabel!
    
    @IBOutlet var infoTextField: UITextField!
        
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var underline: UIView!
    
    var returnValue: ((_ value: String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        infoTextField.delegate = self
    }
    
    var isEditable: Bool = false {
        didSet {
            infoTextField.isEnabled = isEditable
            underline.isHidden = !isEditable
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underline.backgroundColor = .orange
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        underline.backgroundColor = .lightGray
        returnValue?(textField.text ?? "") // Use callback to return data
    }
}
