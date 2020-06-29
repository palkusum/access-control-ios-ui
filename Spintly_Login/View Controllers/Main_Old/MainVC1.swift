//
//  MainVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 01/04/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

class MainVC1: UIViewController {

    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var sideBarView: UIView!
    @IBOutlet var hiderView: UIView!
    
    var showMenu = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarView.backgroundColor = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sideBarView.addGestureRecognizer(tap)
        sideBarView.isHidden = true
        hiderView.isHidden = true
    }
    
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        
        if showMenu {
            leadingConstraint.constant = -280
            self.hiderView.isHidden = true
            UIView.animate(withDuration: 0.4, animations: {
               self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.sideBarView.isHidden = true
            })
        } else {
            leadingConstraint.constant = 0
             self.sideBarView.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
               self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.hiderView.isHidden = false
            })
        }
        
        showMenu = !showMenu
        print("Hello World", showMenu)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        leadingConstraint.constant = -280
        self.hiderView.isHidden = true
        UIView.animate(withDuration: 0.4, animations: {
           self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.sideBarView.isHidden = true
        })
        showMenu = !showMenu
       print("Tap func", showMenu)
    }
}
