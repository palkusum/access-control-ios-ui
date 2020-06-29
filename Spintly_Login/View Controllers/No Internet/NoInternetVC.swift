//
//  NoInternetVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 29/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class NoInternetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
             self.view.frame = self.view.superview!.bounds
         }


}
