//
//  SettingsVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 08/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet var barrierTableView: UITableView!
    
    @IBOutlet var notFoundLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        
        notFoundLabel.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func tableViewSetup() {
        barrierTableView.delegate = self
        barrierTableView.dataSource = self
        barrierTableView.tableFooterView = UIView(frame: .zero)
        barrierTableView.separatorColor = .none
    }

}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserBarrierTableViewCell", owner: self, options: nil)?.first as! UserBarrierTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    
}
