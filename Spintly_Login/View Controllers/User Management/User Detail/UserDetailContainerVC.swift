//
//  UserDetailContainerVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 03/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

protocol UserDetailsChangeListener {
    func didUpdateUser(userId : String)
}

class UserDetailContainerVC: UIViewController {

    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!

    @IBOutlet var listTableView: UITableView!
    @IBOutlet var listTableViewHeightConstraint: NSLayoutConstraint!
    
    private let pages = ["Information", "Permissions", "Access History"]
    
    var userId : String!
    var organisationId = Utils.getCurrentOrganisationDataDetails()!.id
    
    var delegate : UserDetailsChangeListener?
    
    private var userData : UserManagementModel? {
        didSet {
            updateUserDetails()
        }
    }
    
    convenience init(userId : String, organisationId : Int = Utils.getCurrentOrganisationDataDetails()!.id, delegate : UserDetailsChangeListener? = nil) {
        self.init()
        self.userId = userId
        self.organisationId = organisationId
        self.delegate = delegate
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User Details"
        userData = nil
        tableViewSetup()
        getUser()
    }
    
    func tableViewSetup() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView(frame: .zero)
        listTableView.alwaysBounceVertical = false
        listTableViewHeightConstraint.constant = listTableView.contentSize.height
    }
    
    func updateUserDetails() {
        listTableView.isHidden = userData == nil
        self.usernameLabel.text = userData?.name
        self.roleLabel.text = userData?.allPriviledges
    }
    
    func getUser() {
        DispatchQueue.main.async { //Allow time for view to load
            self.view.activityStartAnimating(backgroundColor: .clear)
        }
        let url = "v1/organisations/\(organisationId)/users/\(userId!)"
        APIManager.shared().getRequestWithUrl(url, method: .get, andParameters: [:], withCompletion: { response in
            
            self.view.activityStopAnimating()
            
            if response.status {
                let responseDic = response.object! as [String: Any]
                //print(responseDic["message"] as Any)
                let message = responseDic["message"] as! [String: Any]
                
                let userDict = message["user"] as! [String: Any]
                self.userData = UserManagementModel(object: userDict)
                
            } else {
                UIAlertController.init(title: "", message: response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor()).show()
            }
        })

    }
}


extension UserDetailContainerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserDetailTableViewCell", owner: self, options: nil)?.first as! UserDetailTableViewCell
        cell.listLabel.text = pages[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch pages[indexPath.row] {
        case "Information":
            let informationVC = InformationVC.init(user: userData!, organisationId: organisationId, delegate: self)
            self.navigationController?.pushViewController(informationVC, animated: true)
        case "Permissions":
            let existingPermission = userData!.access_barriers.map({ (dict) -> AccessBarrierModel in
                AccessBarrierModel(object: dict)
            })
            let permissionVC = PermissionsVC(userId: userId, existingPermission: existingPermission, organisationId: organisationId, updateListener: self)
            self.navigationController?.pushViewController(permissionVC, animated: true)
        case "Access History":
            let userHistoryVC = UserAccessHistoryVC(userId: userId, organisationId: organisationId)
            self.navigationController?.pushViewController(userHistoryVC, animated: true)
        default:
            break
        }
    }
    
}

extension UserDetailContainerVC : UserPermissionsUpdatedListener {
    func didUpdateUserPermissions(for userId: String, assignedBarriers: [AccessBarrierModel]) {
        userData?.access_barriers = assignedBarriers.map{ $0.toDictionary() }
    }
}

extension UserDetailContainerVC : UserInformationUpdatedListener {
    func didUpdateUserInformation(for userId: String) {
        getUser()
        delegate?.didUpdateUser(userId: userId)
    }
    func didDeleteUser(for userId: String) {
        delegate?.didUpdateUser(userId: userId)
        self.navigationController?.popViewController(animated: true)
    }
}
