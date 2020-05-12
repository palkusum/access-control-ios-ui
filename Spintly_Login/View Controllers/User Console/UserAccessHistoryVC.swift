//
//  UserAccessHistoryVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 08/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class UserAccessHistoryVC: UIViewController {

    @IBOutlet var userAccessHistoryTableView: UITableView!
    @IBOutlet var notFoundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Access History"
        tableViewSetup()
        
        notFoundLabel.isHidden = true
 
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }

    func tableViewSetup() {
        userAccessHistoryTableView.delegate = self
        userAccessHistoryTableView.dataSource = self
        userAccessHistoryTableView.separatorStyle = .none
    }

}

extension UserAccessHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserDetailHistoryTableViewCell", owner: self, options: nil)?.first as! UserDetailHistoryTableViewCell
        cell.selectionStyle = .none
        cell.directionLabel.textColor = UIColor.greenColor()
//        cell.directionLabel.textColor = UIColor.redColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         guard let headerView = view as? UITableViewHeaderFooterView else { return }
     
        headerView.contentView.backgroundColor = .white
        headerView.textLabel?.textColor = .black
        headerView.textLabel?.font = .systemFont(ofSize: 17)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Access History"
    }
    
    
}
