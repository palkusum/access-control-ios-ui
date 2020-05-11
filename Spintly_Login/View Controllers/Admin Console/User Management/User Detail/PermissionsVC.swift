//
//  PermissionsVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 22/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class PermissionsVC: UIViewController {

    @IBOutlet var permissionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarSetup()
        tableViewSetup()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func navigationBarSetup() {
       self.title =  "Permissions"
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePermission))
    }
    
    func tableViewSetup() {
        permissionsTableView.delegate = self
        permissionsTableView.dataSource = self
        permissionsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    @objc func savePermission() {
        
    }

}

extension PermissionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PermissionsTableViewCell", owner: self, options: nil)?.first as! PermissionsTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
