//
//  MenuViewController.swift
//  DailyRun
//
//  Created by randy on 15/8/17.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
class RecordsViewController: UITableViewController {
    override func viewDidLoad() {
        self.title = "运动记录"
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "List"), style: .Plain, target: self, action: "toggleMenu")
        self.navigationItem.leftBarButtonItem = menuBarButton
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //self.tableView.registerClass(RunDataCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(RunData.allObjects().count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RunDataCell
        let runData = RunData.allObjects().sortedResultsUsingProperty("date", ascending: false)[UInt(indexPath.row)] as! RunData
        //println("\(runData.date.dateString)")
        cell.dateLabel.text = runData.date.dateString
        var distanceText = String(format: "%.2f",runData.distance)+"公里"
        var attributedDistanceText = NSMutableAttributedString(string: distanceText)
        attributedDistanceText.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir Heavy", size: 35)!, range: NSMakeRange(0, count(distanceText)-2))
        attributedDistanceText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange(count(distanceText)-2,2))
        cell.distanceLabel.attributedText = attributedDistanceText
        cell.paceLabel.text = String(format: "%.2f",runData.pace)
        cell.durationLabel.text = runData.duration.timeFormatted
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RunDataCell
        let runData = RunData.allObjects().sortedResultsUsingProperty("date", ascending: false)[UInt(indexPath.row)] as! RunData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailVC.runData = runData
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
