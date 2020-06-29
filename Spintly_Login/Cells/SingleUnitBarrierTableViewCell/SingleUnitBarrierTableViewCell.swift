//
//  SingleUnitBarrierTableViewCell.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 10/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class SingleUnitBarrierTableViewCell: UITableViewCell {

    
    @IBOutlet var barrierNameLabel: UILabel!
    
    @IBOutlet var barrierLocationLabel: UILabel!
    
    @IBOutlet var checkinCheckoutButton: UIButton!
    
    @IBOutlet var statusLabel: UILabel!
    
    func setCheckedIn(_ isCheckedIn : Bool) {
        if (isCheckedIn) {
            checkinCheckoutButton.setTitle("Check-out", for: .normal)
            checkinCheckoutButton.setTitleColor(.red, for: .normal)
            checkinCheckoutButton.borderButton(.red)
            statusLabel.text = "Checked-in"
            
        } else {
            checkinCheckoutButton.setTitle("Check-in", for: .normal)
            checkinCheckoutButton.setTitleColor(.green, for: .normal)
            checkinCheckoutButton.borderButton(.green)
            statusLabel.text = "Checked-out"
        }
    }
    
}
