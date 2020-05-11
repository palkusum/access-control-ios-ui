//
//  ViewController.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 02/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

struct menuArray {
    var opened: Bool
    var name: String!
    var logo: String!
    var sectionData: [String]!
}

struct organisationArray {
    var logo: String!
    var name: String!
}


class MainVC: UIViewController {
    

    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var customView: UIView!
    @IBOutlet var sideBarView: UIView!
    @IBOutlet var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var hiderView: UIView!
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    @IBOutlet var organisationNameLabel: UILabel!
    

    @IBOutlet var dropdownImage: UIButton!
    
    var showMenu = false
    var menuList = [menuArray]()
    var organisationList = [organisationArray]()
    var switch_organisation = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      menuArray(opened: false, name : "Visitor Management", logo : "visitor_management", sectionData: [])

        menuList = [menuArray(opened: false, name : "Home", logo : "home", sectionData: []),
                    menuArray(opened: false, name : "Admin Console", logo : "admin_console",
                              sectionData: ["Access History", "User Management"]),
                    menuArray(opened: false, name : "User Console", logo : "user_console", sectionData: ["Access History", "Settings"]),
                    menuArray(opened: false, name : "Help & Support", logo : "help", sectionData: []),
                    menuArray(opened: false, name : "About", logo : "about", sectionData: []),
                    menuArray(opened: false, name : "Logout", logo : "logout", sectionData: [])]
        
        organisationList = [organisationArray(logo: "company_placeholder", name: "Mrinq Technologies"),
                            organisationArray(logo: "company_placeholder", name: "QA Test1"),
                            organisationArray(logo: "company_placeholder", name: "Single Unit Organisation"),
                            organisationArray(logo: "company_placeholder", name: "Spintly Demo")]
        
        
        let firstViewController = HomeVC()
        addChild(firstViewController)
        customView.addSubview(firstViewController.view)
        firstViewController.didMove(toParent: self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        hiderView.addGestureRecognizer(tap)
        sideBarView.isHidden = true
        hiderView.isHidden = true
        navigationBarSetup()
        sideMenuTableViewSetUp()
        headerViewSetUp()
    }
    
    func navigationBarSetup() {
        self.title = "Mrinq Technologies"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ham_menu"), style: .plain, target: self, action: #selector(toggleDrawer))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreButtonAction))
    }
    
    func headerViewSetUp() {
      userImageView?.image = UIImage(named: "user")
      usernameLabel?.text = "Kusum Pal"
      roleLabel?.text = "Administrator"
      organisationNameLabel?.text = "Mrinq Technologies"
      dropdownImage.setImage(UIImage(named: "down_arrow"), for: .normal)
    }
    
    func sideMenuTableViewSetUp() {
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.separatorStyle = .none
    }
    
    @IBAction func dropDownImageButton(_ sender: UIButton) {
        if switch_organisation {
            dropdownImage.setImage(UIImage(named: "down_arrow"), for: .normal)
        } else {
            dropdownImage.setImage(UIImage(named: "up_arrow"), for: .normal)
        }
        switch_organisation = !switch_organisation
        sideMenuTableView.reloadData()
        print("down arrow", switch_organisation)
       }

    @objc func toggleDrawer() {
         if showMenu {
           sideMenuLeadingConstraint.constant = -280
           self.hiderView.isHidden = true
           UIView.animate(withDuration: 0.4, animations: {
              self.view.layoutIfNeeded()
           }, completion: { (true) in
               self.sideBarView.isHidden = true
           })
       } else {
           sideMenuLeadingConstraint.constant = 0
            self.sideBarView.isHidden = false
           UIView.animate(withDuration: 0.4, animations: {
              self.view.layoutIfNeeded()
           }, completion: { (true) in
               self.hiderView.isHidden = false
           })
       }
        print("Hello World", showMenu)
       showMenu = !showMenu
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        sideMenuLeadingConstraint.constant = -280
        self.hiderView.isHidden = true
        UIView.animate(withDuration: 0.4, animations: {
           self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.sideBarView.isHidden = true
        })
        showMenu = !showMenu
       print("Tap func", showMenu)
    }

    @objc func moreButtonAction() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "About", style: .default, handler: { _ in
                self.showAppVersionAlert()
            }))
            
            alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { _ in
                self.showSignOutAlert()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    func showSignOutAlert() {
        let alert = UIAlertController(title: "Sign out?", message: "Are you sure you want to Sign Out?",   preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAppVersionAlert() {
        let alert = UIAlertController(title: "App Version", message: "1.0",   preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension MainVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if switch_organisation {
          return 1
        } else {
          return menuList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switch_organisation {
            return organisationList.count
        } else if menuList[section].opened == true {
            return menuList[section].sectionData!.count + 1
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if switch_organisation {
            let cell = Bundle.main.loadNibNamed("SideMenuListTableViewCell", owner: self, options: nil)?.first as! SideMenuListTableViewCell
            cell.listImageView?.image = UIImage(named: organisationList[indexPath.row].logo)
            cell.listLabel?.text = organisationList[indexPath.row].name
            return cell
            
        } else if indexPath.row == 0 {
             let cell = Bundle.main.loadNibNamed("SideMenuListTableViewCell", owner: self, options: nil)?.first as! SideMenuListTableViewCell
             cell.listImageView?.image = UIImage(named: menuList[indexPath.section].logo)
             cell.listLabel?.text = menuList[indexPath.section].name
             return cell
            
        } else {
            let cell = Bundle.main.loadNibNamed("SubMenuViewCell", owner: self, options: nil)?.first as! SubMenuViewCell
            cell.subMenuLabel?.text = menuList[indexPath.section].sectionData?[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if switch_organisation {
            return 60
        } else if indexPath.row == 0 {
                return 60
        } else {
                return 37
            }
    }
    
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = Bundle.main.loadNibNamed("SideNavFooterView", owner: self, options: nil)?.first as! UIView
//        return footerView
//
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if switch_organisation {
            organisationNameLabel?.text = organisationList[indexPath.row].name
            dropdownImage.setImage(UIImage(named: "down_arrow"), for: .normal)
            switch_organisation = !switch_organisation
            sideMenuTableView.reloadData()
        } else {
            switch menuList[indexPath.section].name {
            case "Home":
                addChildController(HomeVC())
            case "Admin Console":
                if menuList[indexPath.section].opened == true {
                    menuList[indexPath.section].opened = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    sideMenuTableView.reloadSections(sections, with: .none)
                } else {
                    menuList[indexPath.section].opened = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    sideMenuTableView.reloadSections(sections, with: .none)
                }
                if indexPath.row == 0 {
                    
                } else {
                    switch  menuList[indexPath.section].sectionData[indexPath.row - 1] {
                    case "Access History":
                        addChildController(AccessHistoryVC())
                    case "User Management":
                        addChildController(UserManagementVC())
                    case "Leave Management":
                        addChildController(LeaveManagementVC())
                    default:
                        break
                    }
                }
            case "Visitor Management":
                addChildController(VisitorManagementVC())
            case "User Console":
                if menuList[indexPath.section].opened == true {
                    menuList[indexPath.section].opened = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    sideMenuTableView.reloadSections(sections, with: .none)
                } else {
                    menuList[indexPath.section].opened = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    sideMenuTableView.reloadSections(sections, with: .none)
                }
                if indexPath.row == 0 {
                    
                } else {
                    switch  menuList[indexPath.section].sectionData[indexPath.row - 1] {
                    case "Access History":
                        addChildController(UserAccessHistoryVC())
                    case "Settings":
                        addChildController(SettingsVC())
                    default:
                        break
                    }
                }
            case "Help & Support":
                addChildController(HelpAndSupportVC())
            case "About":
                toggleDrawer()
                self.showAppVersionAlert()
            case "Logout":
                toggleDrawer()
                self.showSignOutAlert()
            default:
                break
            }
        }
    }
    
    
    func addChildController(_ child: UIViewController) {
        self.children.forEach { (UIViewController) in
            UIViewController.removeFromParent()
        }
        customView.subviews.forEach { (UIView) in
            UIView.removeFromSuperview()
        }
        toggleDrawer()
        addChild(child)
        customView.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
