//
//  GpsVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 19/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class GpsVC: UIViewController {
    
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var checkinCheckoutButton: UIButton!
    
    var isCurrentStatusCheckedIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "GPS Attendance"
        checkinCheckoutButton.setTitle("Check-in", for: .normal)
        checkinCheckoutButton.setTitleColor(UIColor.greenColor(), for: .normal)
        checkinCheckoutButton.borderButton(UIColor.greenColor())
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        if isCurrentStatusCheckedIn {
            statusLabel.text = "Checked-out"
            statusLabel.textColor = UIColor.redColor()
            checkinCheckoutButton.setTitle("Check-in", for: .normal)
            checkinCheckoutButton.setTitleColor(UIColor.greenColor(), for: .normal)
            checkinCheckoutButton.borderButton(UIColor.greenColor())
        } else {
            statusLabel.text = "Checked-in"
            statusLabel.textColor = UIColor.greenColor()
            checkinCheckoutButton.setTitle("Check-out", for: .normal)
            checkinCheckoutButton.setTitleColor(UIColor.redColor(), for: .normal)
            checkinCheckoutButton.borderButton(UIColor.redColor())
        }
    
        isCurrentStatusCheckedIn = !isCurrentStatusCheckedIn
    }
}
