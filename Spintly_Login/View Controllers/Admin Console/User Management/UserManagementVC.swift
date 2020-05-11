//
//  UserManagementVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 08/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class UserManagementVC: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var userListTableView: UITableView!
    
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
        userListTableView.delegate = self
        userListTableView.dataSource = self
        userListTableView.tableFooterView = UIView(frame: .zero)
    }

   func searchBarSetup() {
        searchBar.searchBarStyle = UISearchBar.Style.minimal
               searchBar.placeholder = " Search..."
               searchBar.backgroundColor = UIColor.blue
//               searchBar.showsCancelButton = true
               searchBar.showsBookmarkButton = false
               searchBar.tintColor = UIColor.white
//    searchBar.textField.textColor = UIColor.white
//               searchBar.textField?.clearButtonMode = .never
    }
    
    @IBAction func AddUserButton(_ sender: UIButton) {
        
        let addUseController = AddUserStep1VC()
        self.navigationController?.pushViewController(addUseController, animated: true)
    }
    
    
}

extension UserManagementVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserListTableViewCell", owner: self, options: nil)?.first as! UserListTableViewCell
        
        cell.signupPendingLabel.isHidden = false
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
           headerView.contentView.backgroundColor = .white
           headerView.textLabel?.textColor = .black
           headerView.textLabel?.font = .systemFont(ofSize: 17)
       }

       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return "User List"
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(UserDetailContainerVC(), animated: false)
    }
    
}
