//
//  AddAccessBarriersTableViewCell.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 20/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AddAccessBarriersTableViewCell: UITableViewCell {

    @IBOutlet var checkboxButton: UIButton!
    
    @IBOutlet var barrierLabel: UILabel!
    
    override func awakeFromNib() {
        checkboxButton.setImage(UIImage(named: "check_box_disabled"), for: [.disabled, .selected])
        checkboxButton.setImage(UIImage(named: "check_box_active"), for: .selected)
        checkboxButton.setImage(UIImage(named: "check_box_inactive"), for: .normal)
    }
}
