//
//  AddUserStep3VC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 16/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AddUserStep3VC: UIViewController {

    @IBOutlet var accessBarriersTableView: UITableView!
    
    var barrierArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        tableViewSetup()
        
        barrierArray = ["Fingerprint Barrier", "New Door Lock", "Office 1 Testing", "New Office 2", "Callibration Test"]
    
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = view.superview!.bounds
    }
    
    func navigationBarSetup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil)
    }
    
    func tableViewSetup() {
        accessBarriersTableView.delegate = self
        accessBarriersTableView.dataSource = self
        accessBarriersTableView.separatorStyle = .none
        accessBarriersTableView.tableFooterView = UIView(frame: .zero)

   }
}

extension AddUserStep3VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barrierArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AddAccessBarriersTableViewCell", owner: self, options: nil)?.first as! AddAccessBarriersTableViewCell
        cell.barrierLabel?.text = barrierArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
}
