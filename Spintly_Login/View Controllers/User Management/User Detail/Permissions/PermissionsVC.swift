//
//  PermissionsVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 22/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

protocol UserPermissionsUpdatedListener {
    func didUpdateUserPermissions(for userId : String, assignedBarriers : [AccessBarrierModel])
}

class PermissionsVC: UIViewController {

    
    @IBOutlet var permissionsTableView: UITableView!
    
    var organisationId = Utils.getCurrentOrganisationDataDetails()!.id
    var userId = Utils.getLoggedInUserDetails().id
    var userExistingPermission : [AccessBarrierModel] = []
    private var allBarriers : [AccessBarrierModel] = []
    
    var listener : UserPermissionsUpdatedListener?
    
    convenience init(userId : String, existingPermission : [AccessBarrierModel], organisationId: Int = Utils.getCurrentOrganisationDataDetails()!.id ,updateListener : UserPermissionsUpdatedListener? = nil) {
        self.init()
        self.userId = userId
        self.organisationId = organisationId
        self.userExistingPermission = existingPermission
        self.listener = updateListener
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarSetup()
        tableViewSetup()
        
        allBarriers = userExistingPermission.map({ (existingBarrier) -> AccessBarrierModel in
            let barrier = AccessBarrierModel.init(object: existingBarrier.toDictionary())
            barrier.isSelected = true
            return barrier
        })
        permissionsTableView.reloadData()
        getUnassignedPermissions()
    }
    
//    override func viewDidLayoutSubviews() {
//        self.view.frame = self.view.superview!.bounds
//    }
    
    func navigationBarSetup() {
       self.title = "Permissions"
    }
    
    func hideSaveButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func showSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePermission))
    }
    
    func tableViewSetup() {
        permissionsTableView.delegate = self
        permissionsTableView.dataSource = self
        permissionsTableView.tableFooterView = UIView(frame: .zero)
        permissionsTableView.register(nibWithCellClass: PermissionsTableViewCell.self)
    }
    
    func getUnassignedPermissions() {
        DispatchQueue.main.async {
            self.view.activityStartAnimating(backgroundColor: .clear)
        }

        let url = "organisations/\(organisationId)/users/\(userId)/permissions/new"

        APIManager.shared().getRequestWithUrl(url, method: .get, andParameters: nil, withCompletion: { response in
            
            self.view.activityStopAnimating()
            
            if response.status {
                let responseDic = response.object! as [String: Any]
                //print(responseDic["message"] as Any)
                let message = responseDic["message"] as! [String: Any]
                
                for barrierDict in message["access_barriers"] as! [[String: Any]] {
                    let barrier = AccessBarrierModel(object: barrierDict)
                    barrier.isSelected = false
                    self.allBarriers.append(barrier)
                }
                
                self.permissionsTableView.reloadData()
                
            } else {
                UIAlertController.init(title: "", message: response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor()).show()
            }
        })
    }
    
    @objc func savePermission() {
        var dict = [String : Any]()
        
        var barriers = [[String : Any]]()
        
        for barrier in allBarriers {
            if (barrier.isSelected) {
                barriers.append(["id" : barrier.id])
            } else {
                barriers.append(["id" : barrier.id, "_destroy" : 1])
            }
        }
        
        dict["access_barriers"] = barriers
        let url = "organisations/\(organisationId)/users/\(userId)/permissions"
        
        self.hideSaveButton()
        self.view.activityStartAnimating(backgroundColor: .clear)
        
        APIManager.shared().postRequestWithJsonUrl(url, method: .patch, andParameters: dict, withCompletion: { response in
            
            self.view.activityStopAnimating()
            
            if response.status {
                
                let responseDic = response.object! as [String: Any]
                
                let message = responseDic["message"] as! [String: Any]
                
                self.userExistingPermission = (message["access_barriers"] as! [[String: Any]]).map({ (dict) -> AccessBarrierModel in
                    let barrier = AccessBarrierModel.init(object: dict)
                    barrier.isSelected = true
                    return barrier
                })
                self.listener?.didUpdateUserPermissions(for: self.userId, assignedBarriers: self.userExistingPermission)
                
                let alert = UIAlertController(title: "Success", message: "Permissions successfully updated", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Ok", style: .default))
                self.present(alert, animated: true)
                
            }else {
                self.showSaveButton()
                UIAlertController.init(title: response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED, message: "", defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor()).show()
            }
            
        })
    }

}

extension PermissionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBarriers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PermissionsTableViewCell.self)
        let barrier = allBarriers[indexPath.row]
        cell.barrierNameLabel.text = barrier.name
        cell.locationLabel.text = barrier.location
        cell.checkbox.isSelected = barrier.isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let barrier = allBarriers[indexPath.row]
        barrier.isSelected = !barrier.isSelected
        tableView.reloadRows(at: [indexPath], with: .automatic)
        showSaveButton()
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
}
