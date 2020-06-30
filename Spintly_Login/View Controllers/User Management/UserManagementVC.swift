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
    
    var searchText = ""
    var paginationDictionary = [String : Any]()
    var isLoading = false
    
    var currentOrganisation = Utils.getCurrentOrganisationDataDetails()!
    
    var userList = [UserManagementModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        searchBar.delegate = self
        notFoundLabel.isHidden = true
        
        tapToHideKeyboard()
        
        fetchUsers()

    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }
    
    
    func tableViewSetup() {
        userListTableView.register(nibWithCellClass: UserListTableViewCell.self)
        userListTableView.delegate = self
        userListTableView.dataSource = self
        userListTableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func AddUserButton(_ sender: UIButton) {
        
        let addUseController = AddUserStep1VC(organisationId: currentOrganisation.id, delegate: self)
        self.navigationController?.pushViewController(addUseController, animated: true)
    }
    
    func fetchUsers(shouldClear : Bool = true) {
        
        var dict = [String: Any]()

        if paginationDictionary["current_page"] == nil || shouldClear {
            self.userList.removeAll()
            paginationDictionary = [:]
            self.userListTableView.reloadData()
        }
        let page = (paginationDictionary["current_page"] as? Int ?? 0) + 1
        let per_page = paginationDictionary["per_page"] as? Int ?? 15
        
        let paginationDict = ["page":page,"per_page":per_page]
        print(paginationDict)
        
        dict["pagination"] = paginationDict
        dict["filters"] = ["search" : searchText]
        
        notFoundLabel.isHidden = true

        self.userListTableView.addFooterLoader()
        self.isLoading = true

        let url = "organisations/\(currentOrganisation.id)/users/list"

        APIManager.shared().postRequestWithJsonUrl(url, method: .post, andParameters: dict, withCompletion: { response in
            
            self.userListTableView.removeFooterLoader()
            self.isLoading = false
            
            if response.status {
                let responseDic = response.object! as [String: Any]
                //print(responseDic["message"] as Any)
                let responseUsersDictionary = responseDic["message"] as! [String: Any]
                
                for userDict in responseUsersDictionary["users"] as! [[String: Any]] {
                    self.userList.append(UserManagementModel(object: userDict))
                }
                
                self.paginationDictionary = responseUsersDictionary["pagination"] as! [String: Any]
                self.notFoundLabel.isHidden = self.userList.count > 0
                self.userListTableView.reloadData()
                
            } else {
                UIAlertController.init(title: "", message: response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor()).show()
            }
        })

    }
    
}

extension UserManagementVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserListTableViewCell.self)
        let user = userList[indexPath.item]
        cell.userImageView.image = UIImage(named: "ic_profile_placeholder")
        cell.usernameLabel.text = user.name
        cell.roleLabel.text = user.allPriviledges
        cell.signupPendingLabel.isHidden = user.isSignedUp
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.userList.count-1) && paginationDictionary["current_page"] != nil {
            
            let totalData = paginationDictionary["total"] as! Int
            
            if userList.count < totalData, !isLoading {
                self.fetchUsers(shouldClear: false)
            }
        }
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
        let vc = UserDetailContainerVC(userId: userList[indexPath.item].id, organisationId: currentOrganisation.id)
        vc.organisationId = currentOrganisation.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
}

extension UserManagementVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearchAPICall), object: nil)
        self.perform(#selector(performSearchAPICall), with: nil, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if !isLoading {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearchAPICall), object: nil)
            fetchUsers()
        }
    }
    
    @objc private func performSearchAPICall() {
        fetchUsers()
    }
}

extension UserManagementVC : UserAddListener, UserDetailsChangeListener {
    func didUpdateUser(userId: String) {
        fetchUsers()
    }
    
    func didAddUser() {
        fetchUsers()
    }
}

