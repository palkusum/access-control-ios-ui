//
//  Extension.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 09/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import UIKit



extension UITextField {

    func textFieldStyle() {
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.1
    }
    
    func underLineTextField(_ color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func textFieldIcon(_ viewMode: String , _ image: String) {
        
        let imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height:24))
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageUIView.addSubview(imageView)
        
        if (viewMode == "rightView") {
            self.rightView = imageUIView
            self.rightViewMode = .always
        } else {
            self.leftView = imageUIView
            self.leftViewMode = .always
        }
    }

}

extension UITextView {
    
    func underLineTextView(_ color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


extension UIButton {
    func borderButton(_ color: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        layer.cornerRadius = 4
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }
}

extension UINavigationController {

    func setStatusBar() {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.262745098, blue: 0.4588235294, alpha: 1)
        view.addSubview(statusBarView)
    }

}

extension UIColor {
    
    static func myColor() -> UIColor {
    if #available(iOS 13, *) {
        return UIColor.init { (trait) -> UIColor in
            // the color can be from your own color config struct as well.
            return trait.userInterfaceStyle == .dark ? UIColor.darkStatusColor() : UIColor.primaryColor()
        }
    }
     else { return UIColor.primaryColor() }
    }
    
    
    class func primaryColor() -> UIColor {
        return UIColor (red: 28/255.0, green: 111/255.0, blue: 159/255.0, alpha: 1.0)
    }
    
    class func primaryDarkColor() -> UIColor {
        return UIColor (red: 49/255.0, green: 67/255.0, blue: 117/255.0, alpha: 1.0)
    }
    
    class func redColor() -> UIColor {
        return UIColor (red: 244/255.0, green: 67/255.0, blue: 54/255.0, alpha: 1.0)
    }
    
    class func greenColor() -> UIColor {
        return UIColor (red: 76/255.0, green: 175/255.0, blue: 80/255.0, alpha: 1.0)
    }
    
    class func orangeColor() -> UIColor {
        return UIColor (red: 239/255.0, green: 106/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    class func greyColor() -> UIColor {
        return UIColor (red: 108/255.0, green: 121/255.0, blue: 127/255.0, alpha: 1.0)
    }
    
    class func darkBlueColor() -> UIColor {
        return UIColor (red: 0/255.0, green: 46/255.0, blue: 72/255.0, alpha: 1.0)
    }
    
    class func darkStatusColor() -> UIColor {
        return UIColor (red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
    }
    
    
}
