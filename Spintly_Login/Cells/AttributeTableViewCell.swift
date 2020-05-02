//
//  AttributeTableViewCell.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 17/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AttributeTableViewCell: UITableViewCell {


    @IBOutlet var attributeField: UITextField!
    
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
    
}
