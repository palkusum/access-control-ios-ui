//
//  UserDetailContainerVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 03/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class UserDetailContainerVC: UIViewController {

    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var adminLabel: UILabel!
    @IBOutlet var adminManagerLabel: UILabel!
    @IBOutlet var listTableView: UITableView!
    @IBOutlet var listTableViewHeightConstraint: NSLayoutConstraint!
    
    var listArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listArray = ["Information", "Permissions", "Access History"]
        
        self.title = "User Details"
        tableViewSetup()
        
        
        adminManagerLabel.isHidden = true
    }
    
    func tableViewSetup() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView(frame: .zero)
        listTableViewHeightConstraint.constant = listTableView.contentSize.height
    }
}


extension UserDetailContainerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserDetailTableViewCell", owner: self, options: nil)?.first as! UserDetailTableViewCell
        cell.listLabel.text = listArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch listArray[indexPath.row] {
        case "Information":
            self.navigationController?.pushViewController(InformationVC(), animated: true)
        case "Permissions":
            self.navigationController?.pushViewController(PermissionsVC(), animated: true)
        case "Access History":
            self.navigationController?.pushViewController(HistoryVC(), animated: true)
        default:
            break
        }
    }
    
}
