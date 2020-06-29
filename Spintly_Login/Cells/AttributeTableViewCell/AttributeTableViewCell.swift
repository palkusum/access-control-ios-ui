//
//  AttributeTableViewCell.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 17/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AttributeTableViewCell: UITableViewCell, UITextFieldDelegate {


    @IBOutlet var placeholder: UILabel!
    @IBOutlet var attributeField: UITextField!
    @IBOutlet var underline: UIView!
    @IBOutlet var arrow: UIButton!
    
    @IBOutlet var attributeFieldPlaceholderLabel: UILabel!
    
    func attributeFieldIconSetUp() {
        attributeField.textFieldStyle()
        
        let imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height:24))
        let imageView = UIImageView(image: UIImage(named: "down_arrow"))
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageUIView.addSubview(imageView)
        attributeField.rightView = imageUIView
        attributeField.rightViewMode = .always
        
    }
    
    var isEditable: Bool = false {
        didSet {
            attributeField.isEnabled = isEditable
            underline.isHidden = !isEditable
            arrow.isHidden = !isEditable
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attributeField.delegate = self
    }
    @IBAction func onArrowClicked(_ sender: UIButton) {
        attributeField.becomeFirstResponder()
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
