//
//  MenuViewController.swift
//  DailyRun
//
//  Created by randy on 15/8/17.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
class RecordsViewController: UITableViewController,ENSideMenuDelegate  {
    override func viewDidLoad() {
        self.title = "运动记录"
        self.sideMenuController()?.sideMenu?.delegate = self
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "List"), style: .Plain, target: self, action: "toggleMenu")
        self.navigationItem.leftBarButtonItem = menuBarButton
        //self.tableView.registerClass(RunDataCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(RunData.allObjects().count)
    }
    
    func toggleMenu()
    {
        self.toggleSideMenuView()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RunDataCell
        let runData = RunData.allObjects()[UInt(indexPath.row)] as! RunData
        //println("\(runData.date.dateString)")
        cell.dateLabel.text = runData.date.dateString
        cell.distanceLabel.text = String(format: "%.2f",runData.distance)
        cell.paceLabel.text = String(format: "%.2f",runData.pace)
        cell.durationLabel.text = runData.duration.timeFormatted
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RunDataCell
        let runData = RunData.allObjects()[UInt(indexPath.row)] as! RunData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailVC.runData = runData
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
