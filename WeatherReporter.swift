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
                let json = JSON(data:data)
                let cityCode = json["retData"]["cityCode"].string
                //println("\(json)")
                requestUrl = String(format: weatherUrlBase, cityCode!)
                requestUrl = requestUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                let request = NSURLRequest(URL: NSURL(string: requestUrl)!)
                let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data,response,err) in
                    if err == nil
                    {
                        let json = JSON(data:data)
                        //println("\(json)")
                        let currentTemp = json["result"][currentTempKey].intValue
                        let highTemp = json["result"][highTempKey].intValue
                        let lowTemp = json["result"][lowTempKey].intValue
                        let weatherID = json["result"][weatherIDKey].intValue
                        let weatherIcon = self.weatherIconForWeatherID(weatherID)
                        let weather = WeatherObject(currentTemp: currentTemp, highTemp: highTemp, lowTemp: lowTemp,weatherIcon:weatherIcon!)
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
    
    private class func weatherIconForWeatherID(weatherID:Int)->UIImage?
    {
        switch weatherID
        {
        case 1:
            return UIImage(named: "00")
        case 2:
            return UIImage(named: "01")
        case 3:
            return UIImage(named: "02")
        case 4:
            return UIImage(named: "03")
        case 5:
            return UIImage(named: "04")
        case 6:
            return UIImage(named: "05")
        case 7:
            return UIImage(named: "06")
        case 8:
            return UIImage(named: "07")
        case 9:
            return UIImage(named: "08")
        case 10:
            return UIImage(named: "9")
        case 11:
            return UIImage(named: "10")
        case 12:
            return UIImage(named: "11")
        case 13:
            return UIImage(named: "12")
        case 14:
            return UIImage(named: "13")
        case 15:
            return UIImage(named: "14")
        case 16:
            return UIImage(named: "15")
        case 17:
            return UIImage(named: "16")
        case 18:
            return UIImage(named: "17")
        case 19:
            return UIImage(named: "18")
        case 20:
            return UIImage(named: "19")
        case 21:
            return UIImage(named: "20")
        case 22:
            return UIImage(named: "21")
        case 23:
            return UIImage(named: "22")
        case 24:
            return UIImage(named: "23")
        case 25:
            return UIImage(named: "24")
        case 26:
            return UIImage(named: "25")
        case 27:
            return UIImage(named: "26")
        case 28:
            return UIImage(named: "27")
        case 29:
            return UIImage(named: "28")
        case 30:
            return UIImage(named: "29")
        case 31:
            return UIImage(named: "30")
        case 32:
            return UIImage(named: "31")
        case 33:
            return UIImage(named: "53")
        default:
            break
        }
        return nil
    }
}
