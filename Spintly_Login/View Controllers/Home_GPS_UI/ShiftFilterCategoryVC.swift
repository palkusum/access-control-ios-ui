//
//  ShiftFilterCategoryVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 20/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class ShiftFilterCategoryVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }

    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}

extension ShiftFilterCategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ShiftFilterCategoryTableViewCell", owner: self, options: nil)?.first as! ShiftFilterCategoryTableViewCell
        
        return cell
    }
    
    
}
