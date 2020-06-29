//
//  RolesTableViewCell.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 05/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class RolesTableViewCell: UITableViewCell {

    @IBOutlet var checkBox: UIButton!
    
    var returnValue: ((_ value: Bool)->())?

    override func awakeFromNib() {
        checkBox.setImage(UIImage(named: "check_box_disabled"), for: [.disabled, .selected])
        checkBox.setImage(UIImage(named: "check_box_active"), for: .selected)
        checkBox.setImage(UIImage(named: "check_box_inactive"), for: .normal)
        checkBox.addTarget(self, action: #selector(self.toggleState(_:)), for: .touchUpInside)
    }
    
    @objc func toggleState(_ button : UIButton) {
        button.isSelected = !button.isSelected
        returnValue?(button.isSelected)
    }
    
    
    
}
