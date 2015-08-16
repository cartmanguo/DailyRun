//
//  RunViewController.swift
//  DailyRun
//
//  Created by GuoCheng on 15/8/16.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import MapKit
import HealthKit
import CoreLocation
class RunViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var signalView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    lazy var locationManager:CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = CLActivityType.Fitness
        _locationManager.distanceFilter = 10
        return _locationManager
        }()
    lazy var duration:Int = 0
    lazy var distance:Double = 0
    var updateTimer:NSTimer?
    var locations:[CLLocation] = []
    var startRunning = false
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    @IBAction func startPressed(sender: AnyObject) {
        if startRunning == false
        {
            mapView.hidden = false
            locations.removeAll(keepCapacity: false)
            duration = 0
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
            startButton.setTitle("停止", forState: .Normal)
            startButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        }
        else
        {
            let alert = UIAlertController(title: "确认要终止本次跑步吗?", message: "", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {(action) in
                self.updateTimer?.invalidate()
                self.startButton.setTitle("Start!", forState: .Normal)
                self.startButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1.0), forState: .Normal)
                self.locationManager.stopUpdatingLocation()
                self.performSegueWithIdentifier("Detail", sender: nil)
            })
            let cancelAction = UIAlertAction(title: "No,继续跑", style: UIAlertActionStyle.Cancel, handler: {(action) in
            })
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        startRunning = !startRunning
    }
    
    func update()
    {
        duration++
        let hkSecondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: Double(duration))
        timeLabel.text = "时间:" + hkSecondsQuantity.description
        let mileDistance = distance/1000
        let hkDistanceQuantity = HKQuantity(unit: HKUnit.mileUnit(), doubleValue: mileDistance)
        distanceLabel.text = String(format: "%.2f", mileDistance) + "公里"
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let pace = distance/Double(duration)
        let pacePerKilometers = 1000/pace/60
        let hkPaceQuantity = HKQuantity(unit: paceUnit, doubleValue: pace)
        paceLabel.text = "配速:" + String(format: "%.2f",pacePerKilometers)
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Run Stopped", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Save", "Discard")
        actionSheet.actionSheetStyle = .Default
        actionSheet.showInView(view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}

extension RunViewController:CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let latest = locations.last as! CLLocation
        if (latest.horizontalAccuracy < 0)
        {
            // No Signal
            signalView.image = UIImage(named: "Gps_Weak")
        }
        else if (latest.horizontalAccuracy > 163)
        {
            // Poor Signal
            signalView.image = UIImage(named: "Gps_Weak")
        }
        else if (latest.horizontalAccuracy > 48)
        {
            // Average Signal
            signalView.image = UIImage(named: "Gps_Normal")
        }
        else
        {
            // Full Signal
            signalView.image = UIImage(named: "Gps_Good")
        }
        if startRunning
        {
            for location in locations as! [CLLocation]
            {
                if self.locations.count > 0
                {
                    distance += location.distanceFromLocation(self.locations.last)
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    //                    mapView.setRegion(region, animated: true)
                    //
                    //                    mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                }
                self.locations.append(location)
            }
        }
    }
}

extension RunViewController: MKMapViewDelegate
{
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if !overlay.isKindOfClass(MKPolyline) {
            return nil
        }
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }
}

// MARK: UIActionSheetDelegate
extension RunViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //save
//        if buttonIndex == 1 {
//            saveRun()
//            performSegueWithIdentifier(DetailSegueName, sender: nil)
//        }
//            //discard
//        else if buttonIndex == 2 {
//            navigationController?.popToRootViewControllerAnimated(true)
//        }
    }
    
    func saveRun()
    {
//        let run = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: managedObjectContext!) as! Run
//        run.distance = distance
//        run.duration = NSNumber(integer: duration)
//        run.timestamp = NSDate()
//        
//        var savedLocations = [Location]()
//        for location in locations {
//            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location",
//                inManagedObjectContext: managedObjectContext!) as! Location
//            savedLocation.timestamp = location.timestamp
//            savedLocation.latitude = location.coordinate.latitude
//            savedLocation.longitude = location.coordinate.longitude
//            savedLocations.append(savedLocation)
//        }
//        run.locations = NSOrderedSet(array: savedLocations)
//        self.run = run
//        var err:NSError?
//        let success = managedObjectContext?.save(&err)
//        if success == false
//        {
//            NSLog("%@", "failed")
//        }
//        
//        //realm
//        let runObj = RunData()
//        for location in locations {
//            let locations = Locations()
//            locations.latitude = location.coordinate.latitude
//            locations.longitude = location.coordinate.longitude
//            locations.timestamp = location.timestamp
//            runObj.locations.addObject(locations)
//        }
//        
//        runObj.duration = duration
//        runObj.distance = CGFloat(distance)
//        runObj.date = NSDate(timeIntervalSinceNow: 0)
//        runObj.note = "hello"
//        runObj.pace = 6.3
//        self.runData = runObj
//        RunDataManager.sharedInstance.saveRunData(runObj)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
}
