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
    var addUserViewModel : AddUserViewModel!
    var attributePickerViews = [ToolbarPickerView]()
    
    convenience init(viewModel : AddUserViewModel) {
        self.init()
        self.addUserViewModel = viewModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Attributes"
        
        navigationRefresh()
        tableViewSetup()
        populateAttributesTable()
  
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = view.superview!.bounds
    }
    
    func navigationRefresh() {
        if addUserViewModel.barriers.count > 0{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        }
    }
    
    func tableViewSetup() {
        attributeTableView.delegate = self
        attributeTableView.dataSource = self
        attributeTableView.tableFooterView = UIView(frame: .zero)
        attributeTableView.separatorStyle = .none
        attributeTableView.register(nibWithCellClass: AttributeTableViewCell.self)
    }
    
    @objc func nextStep(){
        let addUseController = AddUserStep3VC(viewModel: addUserViewModel)
        self.navigationController?.pushViewController(addUseController, animated: true)
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

    func populateAttributesTable() {
        print("populateAttributesTable")
        attributePickerViews = [ToolbarPickerView]()
        for (i, attribute) in addUserViewModel.attributeList.enumerated() {
            let pickerView = ToolbarPickerView()
            pickerView.tag = i + 100
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.toolbarDelegate = self
            attributePickerViews.append(pickerView)
            pickerView.selectRow((addUserViewModel.selectedAttributeValueIndexes[attribute.id] ?? 1) - 1, inComponent: 0, animated: true)
        }
        attributeTableView.reloadData()
//        self.attributeTableView.removeConstraints(self.attributeTableView.constraints.filter {$0.firstAttribute == .height || $0.secondAttribute == .height})
//        self.attributeTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.attributeTableView.contentSize.height).isActive = true
        
    }

}


extension AddUserStep2VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("attribute count",addUserViewModel.attributeList.count)
        return addUserViewModel.attributeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AttributeTableViewCell.self, for: indexPath)
        let attribute = addUserViewModel.attributeList[indexPath.row]
        let pickerView = attributePickerViews[indexPath.row]
        cell.placeholder.text = attribute.attributeName
        cell.attributeField.placeholder = attribute.attributeName
        cell.attributeField.inputView = pickerView
        cell.attributeField.inputAccessoryView = pickerView.toolbar
        let index = addUserViewModel.selectedAttributeValueIndexes[attribute.id] ?? -1
        if index >= 0 {
            cell.attributeField.text = attribute.values[index]
        } else {
            print("No attributes")
            cell.attributeField.text = "None"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

extension AddUserStep2VC: UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addUserViewModel.attributeList[pickerView.tag - 100].values.count + 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "None"
        } else {
            let attribute = addUserViewModel.attributeList[pickerView.tag - 100]
            return attribute.values[row - 1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //ignore
    }
        
    func didTapDone(_ pickerView: UIPickerView) {
        self.view.endEditing(true)
        let index = pickerView.tag - 100
        addUserViewModel.selectedAttributeValueIndexes[addUserViewModel.attributeList[index].id] = pickerView.selectedRow(inComponent: 0) - 1
        attributeTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        
    }
    
    func didTapCancel(_ pickerView: UIPickerView) {
        self.view.endEditing(true)
        
        pickerView.selectRow((addUserViewModel.selectedAttributeValueIndexes[addUserViewModel.attributeList[pickerView.tag - 100].id] ?? -1) + 1, inComponent: 0, animated : false)
        
    }
    
}

