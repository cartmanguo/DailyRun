//
//  AqiReporter.swift
//  DailyRun
//
//  Created by randy on 15/8/20.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class AqiReporter: NSObject {
    class func requestAqiLevelForCity(cityName:String, success:(data:AqiObject)->(),failed:(err:NSError)->())
    {
        var url = "http://apis.baidu.com/apistore/aqiservice/aqi"
        var requestUrl = String(format: "%@?city=%@", url,cityName)
        requestUrl = requestUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var req = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
        req.timeoutInterval = 6
        req.HTTPMethod = "GET"
        req.addValue("6a4a0df109ab1a4c4a6f3fbb4451a47b", forHTTPHeaderField: "apikey")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let dataTask = session.dataTaskWithRequest(req, completionHandler: {(data,response,err) in
            if err == nil
            {
                let json = JSON(data:data)["retData"]
                let aqi = json[aqiKey].intValue
                let city = json[cityKey].stringValue
                let level = json[levelKey].stringValue
                let aqiIcon = self.aqiIconForAqiQuality(aqi)
                let aqiObj = AqiObject(aqi: aqi, level: level, city: city, aqiIcon: aqiIcon)
                success(data: aqiObj)
                println(json)
            }
            else
            {
                println("failed")
                failed(err: err)
            }
        })
        dataTask.resume()
    }
    
    private class func aqiIconForAqiQuality(aqi:Int)->UIImage?
    {
        var aqiImage:UIImage?
        if aqi >= 0 && aqi <= 50
        {
            println("Good")
            aqiImage = UIImage(named: "Good")
        }
        else if aqi >= 51 && aqi <= 100
        {
            aqiImage = UIImage(named: "Normal")
        }
        else if aqi >= 101 && aqi <= 150
        {
            aqiImage = UIImage(named: "UnHealthy-1")
        }
        else if aqi >= 151 && aqi <= 200
        {
            aqiImage = UIImage(named: "UnHealthy-2")
        }
        else if aqi >= 201 && aqi <= 300
        {
            aqiImage = UIImage(named: "UnHealthy-3")
        }
        else if aqi >= 301
        {
            aqiImage = UIImage(named: "Hazardous")
        }
        return aqiImage
    }
}
