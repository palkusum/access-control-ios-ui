//
//  Extension.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 09/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {

//    class func appThemeBlueColor() -> UIColor{
//        return UIColor.init(red: 28, green: 112, blue: 159)!
//
//    }
//    class func darkBlueBackgroundColor() -> UIColor{
//        return UIColor.init(red: 21, green: 61, blue: 90)!
//    }
}

extension UITextField {

    func textFieldStyle() {
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.1
    }
    
    func underLineTextField() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func textFieldIcon(_ viewMode: ViewMode, _ image: String) {
        
        let imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height:24))
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageUIView.addSubview(imageView)
        
        if (viewMode == rightViewMode) {
            self.rightView = imageUIView
            self.rightViewMode = .always
        } else {
            self.leftView = imageUIView
            self.leftViewMode = .always
        }
    }

}
