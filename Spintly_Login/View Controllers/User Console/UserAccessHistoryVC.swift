//
//  UserAccessHistoryVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 08/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class UserAccessHistoryVC: UIViewController {

    @IBOutlet var userAccessHistoryTableView: UITableView!
    @IBOutlet var notFoundLabel: UILabel!
    
    private var accessHistoryList = [AccessHistoryModel]()
    
    private var paginationDictionary = [String : Any]()
    private var isLoading = false
    
    var currentOrganisationId = Utils.getCurrentOrganisationDataDetails()!.id
    var userId = Utils.getLoggedInUserDetails().id
    
    convenience init(userId : String, organisationId : Int = Utils.getCurrentOrganisationDataDetails()!.id) {
        self.init()
        self.userId = userId
        self.currentOrganisationId = organisationId
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Access History"
        tableViewSetup()
        
        notFoundLabel.isHidden = true
 
    }
    
    override func viewDidLayoutSubviews() {
        self.view.frame = self.view.superview!.bounds
    }

    func tableViewSetup() {
        userAccessHistoryTableView.delegate = self
        userAccessHistoryTableView.dataSource = self
        userAccessHistoryTableView.separatorStyle = .none
    }
    
    func accessHistoryAPICall(shouldClear : Bool = true) {
           
           var dict = [String: Any]()
           
           if paginationDictionary["current_page"] == nil || shouldClear {
               self.accessHistoryList.removeAll()
               paginationDictionary = [:]
               self.userAccessHistoryTableView.reloadData()
           }
           let page = (paginationDictionary["current_page"] as? Int ?? 0) + 1
           let per_page = paginationDictionary["per_page"] as? Int ?? 10
           
           let paginationDict = ["page":page,"per_page":per_page]
           print(paginationDict, currentOrganisationId, userId)
           
           dict = ["pagination":paginationDict]
           
           // FILTERS

           dict["filters"] = ["user_ids" : [userId]]
           dict["order"] = ["accessedAt" : "desc"]
           
           let url = "organisations/\(currentOrganisationId)/access_history/list"

           self.notFoundLabel.isHidden = true
           self.userAccessHistoryTableView.addFooterLoader()
           self.isLoading = true

           APIManager.shared().postRequestWithJsonUrl(url, method: .post, andParameters: dict, withCompletion: { response in
               
               self.userAccessHistoryTableView.removeFooterLoader()
               self.isLoading = false
               
               if response.status {
                   
                   let response = response.object! as [String: Any]
                   //print(response["message"] as Any)
                   
                   let responseDic = response["message"] as! [String: Any]
                   let responseArray = responseDic["access_history"] as? [[String: Any]] ?? [[String: Any]]()
                   
                   for dic in responseArray {
                       let object = AccessHistoryModel(object: dic)
                       self.accessHistoryList.append(object)
                   }

                   self.paginationDictionary = responseDic["pagination"] as? [String: Any] ?? [String: Any]()
                   self.notFoundLabel.isHidden = self.accessHistoryList.count > 0
                   self.userAccessHistoryTableView.reloadData()
                   
               }else {
                   UIAlertController.init(title: "", message: response.errorMessage ?? UIMessages.API_RESPOSNE_FAILED, defaultActionButtonTitle: "Ok", tintColor: UIColor.darkBlueBackgroundColor()).show()
               }
           })
       }

}

extension UserAccessHistoryVC: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return accessHistoryList.count
      }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserDetailHistoryTableViewCell.self, for: indexPath)
        let accessHistory = accessHistoryList[indexPath.row]
        let barrier = AccessBarrierModel(object: accessHistory.AccessBarrier)
        
        let date = NSDate.getDateFromString(date: accessHistory.accessedAt, inputFormat: DateFormats.API_DATE_FORMAT)!
        cell.dateLabel.text = NSDate.getStringFromDate(date: date, outputFormat: "MMM dd, YYYY")
        cell.timeLabel.text = NSDate.getStringFromDate(date: date, outputFormat: DateFormats.DATE_FORMAT_TIME)
        if accessHistory.direction.count > 0 {
            cell.directionLabel.text = accessHistory.direction.capitalized
            if accessHistory.direction.lowercased() == UIData.DOOR_ENTRY {
                cell.directionLabel.textColor = UIColor.greenColor()
            } else if accessHistory.direction.lowercased() == UIData.DOOR_EXIT{
                cell.directionLabel.textColor = UIColor.redColor()
            } else {
                cell.directionLabel.textColor = UIColor.darkGray
            }
        } else {
            cell.directionLabel.textColor = UIColor.darkGray
            cell.directionLabel.text = UIData.DOOR_OPENED.capitalized
        }
        cell.barrierNameLabel.text = barrier.name
        cell.locationLabel.text = barrier.location
        cell.sourceLabel.image = UIImage(named:accessHistory.source)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(paginationDictionary)
        if indexPath.row == (self.accessHistoryList.count-1) && paginationDictionary["current_page"] != nil {
            
            let totalData = paginationDictionary["total"] as! Int
            
            if accessHistoryList.count < totalData, !isLoading {
                self.accessHistoryAPICall(shouldClear: false)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        100
//    }
    
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
