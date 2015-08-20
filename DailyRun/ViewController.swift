//
//  ViewController.swift
//  DailyRun
//
//  Created by randy on 15/8/13.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import CoreLocation
import ENSwiftSideMenu
class ViewController: UIViewController,CLLocationManagerDelegate,ENSideMenuDelegate{

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var distanceLabel: UICountingLabel!
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var pmIconView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var todayRecordLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var gpsView: UIImageView!
    @IBOutlet weak var smileIcon: UIImageView!
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        println("vdl")
        RunDataManager.sharedInstance.todayRecord()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        distanceLabel.countFrom(distanceLabel.currentValue(), to: RunDataManager.sharedInstance.totalMiles(), withDuration: 0.8)
        if RunDataManager.sharedInstance.didUserRunToday()
        {
            todayRecordLabel.text = String(format: "今天你跑了%.2f公里.", RunDataManager.sharedInstance.todayRecord())
            smileIcon.image = UIImage(named: "Smile")
        }
        else
        {
            todayRecordLabel.text = "你今天还没有跑步哦ˇ﹏ˇ."
            smileIcon.image = UIImage(named: "Sad")
        }
        locationManager.startUpdatingLocation()
        distanceLabel.format = "%.1f"
    }
    
    @IBAction func toggleMenu(sender: AnyObject)
    {
        self.toggleSideMenuView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func getWeather(city:String)
    {
        WeatherReporter.requestForWeatherForCity(city, success: {(data:WeatherObject) in
            dispatch_async(dispatch_get_main_queue(), {() in
                self.tempLabel.text = "当前温度:"+String(format: "%d", data.currentTemp!)+"℃"
                self.todayTempLabel.text = "今天"+String(data.highTemp!) + " / " + String(data.lowTemp!)+"℃"
                self.weatherIconView.image = data.weatherIcon
                })
            
             }, failed: {(err) in
        })
    }
    
    func getAqi(city:String)
    {
        AqiReporter.requestAqiLevelForCity(city, success: {(data:AqiObject) in
            dispatch_async(dispatch_get_main_queue(), {() in
                self.pmLabel.text = "空气质量:"+String(format: "%d,%@", data.aqi!,data.level!)
                self.pmIconView.image = data.aqiIcon
            })
            
            }, failed: {(err) in
        })

    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        let latest = locations.last as! CLLocation
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(latest, completionHandler: {(placemarks,err) in
            if placemarks != nil
            {
                let placemark = placemarks.first as! CLPlacemark
                var city = placemark.locality as NSString
                city = city.substringToIndex(city.length-1)
                self.getWeather(city as String)
                self.getAqi(city as String)
                self.cityLabel.text = placemark.locality
                self.locationManager.stopUpdatingLocation()
            }
            else
            {
                self.locationManager.startUpdatingLocation()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

