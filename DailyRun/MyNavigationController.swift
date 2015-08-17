//
//  MyNavigationController.swift
//  DailyRun
//
//  Created by randy on 15/8/13.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
class MyNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.topViewController.preferredStatusBarStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = ENSideMenu(sourceView: self.view, menuTableViewController: MenuViewController(), menuPosition:.Left)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 180.0 // optional, default is 160
        //sideMenu?.bouncingEnabled = false
        
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
}
