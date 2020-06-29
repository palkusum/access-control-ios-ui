//
//  CardView.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 02/03/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cardCornerRadius : CGFloat = 10
    @IBInspectable var cardShadowOffsetWidth : CGFloat = 0
    @IBInspectable var cardShadowOffsetHeight : CGFloat = 0
    @IBInspectable var cardShadowColor : UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var cardShadowOpacity : Float = 0.15
        
    override func layoutSubviews() {
        layer.cornerRadius = cardCornerRadius
        layer.shadowRadius = cardCornerRadius
        layer.shadowColor = cardShadowColor?.cgColor
        layer.shadowOffset = CGSize.init(width: cardShadowOffsetWidth, height: cardShadowOffsetHeight)
        layer.shadowOpacity = Float(cardShadowOpacity)
    }

}
