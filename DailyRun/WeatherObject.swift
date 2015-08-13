//
//  WeatherObject.swift
//  DailyRun
//
//  Created by randy on 15/8/13.
//  Copyright (c) 2015年 randy. All rights reserved.
//

class WeatherObject: NSObject {
    var currentTemp:Int?
    var highTemp:Int?
    var lowTemp:Int?
    init(currentTemp:Int,highTemp:Int,lowTemp:Int) {
        super.init()
        self.currentTemp = currentTemp
        self.highTemp = highTemp
        self.lowTemp = lowTemp
    }
}
