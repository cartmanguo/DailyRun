//
//  ViewController.swift
//  DailyRun
//
//  Created by randy on 15/8/13.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flipNumberView: JDFlipNumberView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var pmIconView: UIImageView!
    override func viewDidLoad() {
        flipNumberView.digitCount = 5
        flipNumberView.imageBundleName = "JDFlipNumberView"
        flipNumberView.value = 0
        flipNumberView.animateToValue(235, duration: 2.5)
        getWeather()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getWeather()
    {
        WeatherReporter.requestForWeatherForCity("成都", success: {(data:WeatherObject) in
            dispatch_async(dispatch_get_main_queue(), {() in
                self.tempLabel.text = String(format: "%d", data.currentTemp!)+"℃"
                self.todayTempLabel.text = "今天"+String(data.highTemp!) + " / " + String(data.lowTemp!)
                })
            
             }, failed: {(err) in
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

