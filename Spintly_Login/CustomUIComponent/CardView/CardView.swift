//
//  CardView.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 02/03/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 10
    @IBInspectable var shadowOffsetWidth : CGFloat = 0
    @IBInspectable var shadowOffsetHeight : CGFloat = 0
    @IBInspectable var shadowColor : UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var shadowOpacity : Float = 0.2
        
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize.init(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = Float(shadowOpacity)
    }

}
