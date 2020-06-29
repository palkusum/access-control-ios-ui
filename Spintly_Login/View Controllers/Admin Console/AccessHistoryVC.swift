//
//  AccessHistoryVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 08/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class AccessHistoryVC: UIViewController {


    @IBOutlet var barrierField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var accessHistoryTableView: UITableView!
    @IBOutlet var notFoundLabel: UILabel!
    
    var pickerView = ToolbarPickerView()
    var datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    var barrierArray = ["All Barrier","Vasco", "Panjim", "Ponda", "Margao"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notFoundLabel.isHidden = true
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        barrierFieldIconSetUp()
        dateFieldIconSetUp()
        barrierPickerViewSetup()
        createDatePicker()
        tableViewSetup()
  
        barrierField.text = "All Barrier"
        dateField.text = formatter.string(from: Date())

    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    func tableViewSetup() {
        accessHistoryTableView.delegate = self
        accessHistoryTableView.dataSource = self
        accessHistoryTableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    func barrierFieldIconSetUp() {
        barrierField.textFieldStyle()
        
        let imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height:24))
        let imageView = UIImageView(image: UIImage(named: "down_arrow"))
        imageView.frame = CGRect(x: 16, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageUIView.addSubview(imageView)
        barrierField.rightView = imageUIView
        barrierField.rightViewMode = .always
        
    }
    
    func dateFieldIconSetUp() {
        dateField.textFieldStyle()
        
        let imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height:24))
        let imageView = UIImageView(image: UIImage(named: "calendar"))
        imageView.frame = CGRect(x: 10, y: 2, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        imageUIView.addSubview(imageView)
        dateField.leftView = imageUIView
        dateField.leftViewMode = .always
    }

    func barrierPickerViewSetup () {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.toolbarDelegate = self
        pickerView.backgroundColor = .white
        barrierField.inputView = pickerView
        barrierField.inputAccessoryView = pickerView.toolbar
        
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDoneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerCancelTapped))
        toolbar.setItems([cancelButton, spaceButton, doneBtn], animated: true)
        dateField.inputAccessoryView = toolbar
        dateField.inputView = datePicker
        datePicker.datePickerMode = .date
 
    }
    
    @objc func datePickerDoneTapped() {
        dateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func datePickerCancelTapped() {
        dateField.resignFirstResponder()
    }
    
}



extension AccessHistoryVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return barrierArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return barrierArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        barrierField.text = barrierArray[row]
//        barrierField.resignFirstResponder()
    }
}


extension AccessHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AccessHistoryTableViewCell", owner: self, options: nil)?.first as! AccessHistoryTableViewCell
        
                cell.directionLabel.textColor = UIColor.greenColor()
        //        cell.directionLabel.textColor = UIColor.redColor()
        
        return cell
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

extension AccessHistoryVC: ToolbarPickerViewDelegate {

    func didTapDone(_ pickerView: UIPickerView) {
        self.barrierField.resignFirstResponder()
    }

    func didTapCancel(_ pickerView: UIPickerView) {
        self.barrierField.text = nil
        self.barrierField.resignFirstResponder()
    }
}
