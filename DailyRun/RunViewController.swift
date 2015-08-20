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
class RunViewController: UIViewController,CountDownDelegate{
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
    var runData:RunData?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    @IBAction func startPressed(sender: AnyObject) {
        if startRunning == false
        {
            let countDownView = CountDownView(frame:self.view.bounds)
            countDownView.delegate = self
            view.addSubview(countDownView)
            countDownView.startCountDown()
            
        }
        else
        {
            let alert = UIAlertController(title: "确认要终止本次跑步吗?", message: "", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {(action) in
                self.updateTimer?.invalidate()
                self.startButton.setTitle("Start!", forState: .Normal)
                self.startButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1.0), forState: .Normal)
                self.locationManager.stopUpdatingLocation()
                self.startRunning = false
                self.saveRun()
                self.performSegueWithIdentifier("Detail", sender: nil)
            })
            let cancelAction = UIAlertAction(title: "No,继续跑", style: UIAlertActionStyle.Cancel, handler: {(action) in
            })
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    func countDownFinished(countDownView: CountDownView) {
        countDownView.removeFromSuperview()
        mapView.hidden = false
        locations.removeAll(keepCapacity: false)
        duration = 0
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
        startButton.setTitle("停止", forState: .Normal)
        startButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        startRunning = true
        self.navigationItem.hidesBackButton = true
    }
    
    func saveRun()
    {
        let runData = RunData()
        for location in locations {
            let locations = Locations()
            locations.latitude = location.coordinate.latitude
            locations.longitude = location.coordinate.longitude
            locations.timestamp = location.timestamp
            runData.locations.addObject(locations)
        }
        let pace = distance/Double(duration)
        var pacePerKilometers:Double = 0.0
        if pace == 0
        {
            pacePerKilometers = 0
        }
        else
        {
            pacePerKilometers = 1000/pace/60
        }

        runData.duration = duration
        runData.distance = CGFloat(distance)/1000
        runData.date = NSDate(timeIntervalSinceNow: 0)
        runData.pace = pacePerKilometers
        self.runData = runData
        RunDataManager.sharedInstance.saveRunData(runData)
    }

    
    func update()
    {
        duration++
        let hkSecondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: Double(duration))
        timeLabel.text = "时间:" + duration.timeFormatted
        let mileDistance = distance/1000
        let hkDistanceQuantity = HKQuantity(unit: HKUnit.mileUnit(), doubleValue: mileDistance)
        distanceLabel.text = String(format: "%.2f", mileDistance) + "公里"
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let pace = distance/Double(duration)
        var pacePerKilometers:Double = 0.0
        if pace == 0
        {
            pacePerKilometers = 0
        }
        else
        {
            pacePerKilometers = 1000/pace/60
        }
        let hkPaceQuantity = HKQuantity(unit: paceUnit, doubleValue: pace)
        paceLabel.text = "配速:" + String(format: "%.2f",pacePerKilometers)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail"
        {
            let detailtVC = segue.destinationViewController as! DetailViewController
            detailtVC.runData = runData
        }
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
        
    }
}

extension RunViewController: MKMapViewDelegate
{
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if startRunning
        {
            if self.locations.count > 0
            {
                distance += userLocation.location.distanceFromLocation(self.locations.last)
                var coords = [CLLocationCoordinate2D]()
                coords.append(self.locations.last!.coordinate)
                coords.append(userLocation.location.coordinate)
                
                let region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
                
                mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
            }
            self.locations.append(userLocation.location)
        }

    }
    
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
