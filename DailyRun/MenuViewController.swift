//
//  MenuViewController.swift
//  DailyRun
//
//  Created by randy on 15/8/17.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    var selectedMenuItem : Int = 0
    let images = [UIImage(named: "Home"),UIImage(named: "Running")]
    let titles = ["主页","运动记录"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        //tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        //tableView.separatorStyle = .None
        //tableView.backgroundColor = UIColor.whiteColor()
        //tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        tableView.tableFooterView = UIView()
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    

}
