//
//  MyNavigationController.swift
//  DailyRun
//
//  Created by randy on 15/8/13.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
class MyNavigationController: UINavigationController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.topViewController.preferredStatusBarStyle()
    }
    
    override func viewDidLoad() {
    }
    
}
