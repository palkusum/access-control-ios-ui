//
//  HomeVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 05/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AccessAttendanceVC: UIViewController {

    @IBOutlet var barrierTableView: UITableView!
    @IBOutlet var notFoundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         barrierTableViewSetUp()
        
        notFoundLabel.isHidden = true
        
        self.title = "Access & Attendance"
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func barrierTableViewSetUp() {
           barrierTableView.delegate = self
           barrierTableView.dataSource = self
           barrierTableView.separatorStyle = .none
       }

}

extension AccessAttendanceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Normal Barrier
//        let cell = Bundle.main.loadNibNamed("BarrierTableViewCell", owner: self, options: nil)?.first as! BarrierTableViewCell

        
//        Single Unit Barrier
         let cell = Bundle.main.loadNibNamed("SingleUnitBarrierTableViewCell", owner: self, options: nil)?.first as! SingleUnitBarrierTableViewCell
        
//        Checked-out Status
//        cell.checkinCheckoutButton.setTitle("Check-in", for: .normal)
//        cell.checkinCheckoutButton.setTitleColor(.green, for: .normal)
//        cell.checkinCheckoutButton.borderButton(.green)
//        cell.statusLabel.text = "Checked-out"
        
//        Checked-in Status
        cell.checkinCheckoutButton.setTitle("Check-out", for: .normal)
        cell.checkinCheckoutButton.setTitleColor(.red, for: .normal)
        cell.checkinCheckoutButton.borderButton(.red)
        cell.statusLabel.text = "Checked-in"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = .white
        headerView.textLabel?.textColor = .black
        headerView.textLabel?.font = .systemFont(ofSize: 17)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Barrier List"
    }
    
    
}
