//
//  HomeVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 19/05/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class HomeVC1: UIViewController {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
           self.view.frame = self.view.superview!.bounds
    }
    
    @IBAction func onItemCicked(sender: UIButton) {
        print("Item tag", sender.tag)
        
        switch sender.tag {
        case 0:
            print("Access & Attendnace")
            self.navigationController?.pushViewController(AccessAttendanceVC(), animated: true)
        case 1:
            print("GPS Attendnace")
            self.navigationController?.pushViewController(GpsVC(), animated: true)
        case 2:
            print("Dashboard")
            self.navigationController?.pushViewController(DashboardVC(), animated: true)
        default:
            break
        }
    }



}
