//
//  AddUserStep2VC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 15/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AddUserStep2VC: UIViewController, UITextFieldDelegate {

    @IBOutlet var attributeTableView: UITableView!
    
//    var textFieldBeginEditing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        tableViewSetup()
  
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = view.superview!.bounds
    }
    
    func navigationBarSetup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
    }
    
    func tableViewSetup() {
        attributeTableView.delegate = self
        attributeTableView.dataSource = self
        attributeTableView.tableFooterView = UIView(frame: .zero)
        attributeTableView.separatorStyle = .none
    }
    
    @objc func nextStep() {
        let addUseController = AddUserStep3VC()
        self.navigationController?.pushViewController(addUseController, animated: true)
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textFieldBeginEditing = true
//    }

}


extension AddUserStep2VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AttributeTableViewCell", owner: self, options: nil)?.first as! AttributeTableViewCell
       
        cell.selectionStyle = .none
        
//        if textFieldBeginEditing == true {
//             cell.attributeFieldPlaceholderLabel.isHidden = false
//        } else {
//             cell.attributeFieldPlaceholderLabel.isHidden = true
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
