//
//  DashboardVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 19/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var shiftTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard"
        
        segmentedControlSetup ()
        tableViewSetup()
    }
    
    func segmentedControlSetup () {
       let font = UIFont.systemFont(ofSize: 25)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.orangeColor()], for: .normal)
    }
    
    func tableViewSetup() {
       shiftTableView.delegate = self
       shiftTableView.dataSource = self
       shiftTableView.separatorStyle = .none
    }
    
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
//            Todays attendance data
        } else {
//            Yesterdays attendance data
        }

    }
    
}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DashboardAttendanceTableViewCell", owner: self, options: nil)?.first as! DashboardAttendanceTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
}
