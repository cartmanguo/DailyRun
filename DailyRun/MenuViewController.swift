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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? MenuCell
        if (cell == nil) {
            cell = MenuCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
        }
        cell?.imageView?.image = images[indexPath.row]
        cell!.textLabel?.text = titles[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("Selected row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            performSegueWithIdentifier("Home", sender: nil)
            break
        case 1:
            performSegueWithIdentifier("Records", sender: nil)
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4") as! UIViewController
            break
        }
    }

}
