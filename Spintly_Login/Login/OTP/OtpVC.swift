//
//  OtpVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 24/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class OtpVC: UIViewController {

    @IBOutlet var cardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = .zero
    }

}
