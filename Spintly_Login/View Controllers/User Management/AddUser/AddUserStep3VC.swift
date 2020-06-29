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
    
    var addUserViewModel : AddUserViewModel!
    
    convenience init(viewModel : AddUserViewModel) {
        self.init()
        self.addUserViewModel = viewModel
    }
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    }
    
    func tableViewSetup() {
        accessBarriersTableView.delegate = self
        accessBarriersTableView.dataSource = self
        accessBarriersTableView.separatorStyle = .none
        accessBarriersTableView.tableFooterView = UIView(frame: .zero)
        accessBarriersTableView.register(nibWithCellClass: AddAccessBarriersTableViewCell.self)
    }
    
    @objc func save() {
        self.view.activityStartAnimating(backgroundColor: .clear)
        addUserViewModel.addUser { (errorMessage) in
            self.view.activityStopAnimating()
            if let message = errorMessage {
                let alert = UIAlertController.init(title: "", message: message, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor());
                self.present(alert, animated: true)
            }
        }
    }

}

extension AddUserStep3VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addUserViewModel.barriers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AddAccessBarriersTableViewCell.self)
        let barrier = addUserViewModel.barriers[indexPath.row]
        cell.barrierLabel.text = barrier.name
        cell.checkboxButton.isSelected = barrier.isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let barrier = addUserViewModel.barriers[indexPath.row]
        barrier.isSelected = !barrier.isSelected
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
