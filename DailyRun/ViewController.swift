//
//  ViewController.swift
//  DailyRun
//
//  Created by randy on 15/8/13.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import CoreLocation
import SWRevealViewController
class ViewController: UIViewController,CLLocationManagerDelegate{

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
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        RunDataManager.sharedInstance.todayRecord()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 1000.0
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        locationManager.startUpdatingLocation()
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
        distanceLabel.format = "%.1f"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func getWeather(city:String)
    {
        if ((NSUserDefaults.standardUserDefaults().objectForKey("weather_info")) != nil)
        {
            print("save local")
            let data = NSUserDefaults.standardUserDefaults().objectForKey("weather_info") as! [String:Int]
            self.tempLabel.text = "当前温度:" + String(format: "%d", data[currentTempKey]!)+"℃"
            self.todayTempLabel.text = "今天" + String(data[highTempKey]!) + " / " + String(data[lowTempKey]!)+"℃"
            self.weatherIconView.image = WeatherReporter.weatherIconForWeatherID(data[weatherIDKey]!)
        }
        else
        {
            print("ask for weather")
            WeatherReporter.requestForWeatherForCity(city, success: {(data:WeatherObject) in
                dispatch_async(dispatch_get_main_queue(), {() in
                    self.tempLabel.text = "当前温度:"+String(format: "%d", data.currentTemp!)+"℃"
                    self.todayTempLabel.text = "今天"+String(data.highTemp!) + " / " + String(data.lowTemp!)+"℃"
                    self.weatherIconView.image = data.weatherIcon
                    let weatherInfo = [currentTempKey:data.currentTemp!,highTempKey:data.highTemp!,lowTempKey:data.lowTemp!,weatherIDKey:data.weatherID!]
                    NSUserDefaults.standardUserDefaults().setObject(weatherInfo, forKey: "weather_info")
                    NSUserDefaults.standardUserDefaults().synchronize()
                })
                
                }, failed: {(err) in
            })

        }
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update")
        locationManager.stopUpdatingLocation()
        let latest = locations.last as CLLocation!
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(latest, completionHandler: {(placemarks,err) in
            if placemarks != nil
            {
                let placemark = placemarks!.first as CLPlacemark!
                let locality = placemark.locality as NSString?
                if let city = locality
                {
                    print("\(city)")
                    let cityWithoutLastWord = city.substringToIndex(city.length-1)
                    self.getWeather(cityWithoutLastWord as String)
                    self.getAqi(cityWithoutLastWord as String)
                    self.cityLabel.text = placemark.locality
                    self.locationManager.stopUpdatingLocation()

                }
            }
            else
            {
                //self.locationManager.startUpdatingLocation()
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

