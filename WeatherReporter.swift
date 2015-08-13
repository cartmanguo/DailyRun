//
//  WeatherReporter.swift
//  DailyRun
//
//  Created by GuoCheng on 15/8/13.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
class WeatherReporter: NSObject {
    class func requestForWeatherForCity(cityName:String, success:(data:WeatherObject)->(),failed:(err:NSError)->())
    {
        var requestUrl = String(format: cityCodeBase, cityName)
        requestUrl = requestUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let url = NSURL(string: requestUrl)
        let request = NSURLRequest(URL: url!)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data,response,err) in
            if err == nil
            {
                println("ok")
                let json = JSON(data:data)
                let cityCode = json["retData"]["cityCode"].string
                println("\(json)")
                requestUrl = String(format: weatherUrlBase, cityCode!)
                requestUrl = requestUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                let request = NSURLRequest(URL: NSURL(string: requestUrl)!)
                let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data,response,err) in
                    if err == nil
                    {
                        let json = JSON(data:data)
                        println("\(json)")
                        let currentTemp = json["result"][currentTempKey].intValue
                        let highTemp = json["result"][highTempKey].intValue
                        let lowTemp = json["result"][lowTempKey].intValue
                        let weather = WeatherObject(currentTemp: currentTemp, highTemp: highTemp, lowTemp: lowTemp)
                        success(data: weather)
                    }
                    else
                    {
                        failed(err: err)
                    }
                })
                dataTask.resume()
            }
            else
            {
                println("failed")
                failed(err: err)
            }
        })
        dataTask.resume()

    }
}
