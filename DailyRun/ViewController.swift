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

    @IBOutlet weak var flipNumberView: JDFlipNumberView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var pmIconView: UIImageView!
    @IBOutlet weak var todayRecordLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var gpsView: UIImageView!
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        flipNumberView.digitCount = 5
        flipNumberView.imageBundleName = "JDFlipNumberView"
        flipNumberView.value = 0
        flipNumberView.animateToValue(235, duration: 1.2)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func toggleMenu(sender: AnyObject)
    {
        self.toggleSideMenuView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        flipNumberView.stopAnimation()
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let latest = locations.last as! CLLocation
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(latest, completionHandler: {(placemarks,err) in
            if placemarks != nil            {
                let placemark = placemarks.first as! CLPlacemark
                var city = placemark.locality as NSString
                city = city.substringToIndex(city.length-1)
                self.getWeather(city as String)
                self.cityLabel.text = placemark.locality
                self.locationManager.stopUpdatingLocation()
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

