//
//  HistoryVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 05/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableViewSetup()

        self.title = "Access History"
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func historyTableViewSetup() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.separatorStyle = .none
        historyTableView.tableFooterView = UIView(frame: .zero)
//        historyTableView.estimatedRowHeight = 40
        historyTableView.rowHeight = UITableView.automaticDimension
    }


}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserDetailHistoryTableViewCell", owner: self, options: nil)?.first as! UserDetailHistoryTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
