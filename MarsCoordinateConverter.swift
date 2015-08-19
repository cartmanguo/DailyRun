//
//  MarsCoordinateConverter.swift
//  DailyRun
//
//  Created by randy on 15/8/19.
//  Copyright (c) 2015年 randy. All rights reserved.
//

let a = 6378245.0;
let ee = 0.00669342162296594323;
let pi = 3.14159265358979324;
import CoreLocation
class MarsCoordinateConverter: NSObject {
    
//    class func transformFromWGSToGCJ(wgsLoc:CLLocationCoordinate2D)->CLLocationCoordinate2D
//    {
//        var adjustLoc:CLLocationCoordinate2D!
//        if(isLocationOutOfChina(wgsLoc))
//        {
//            adjustLoc = wgsLoc;
//        }
//        else
//        {
//            var adjustLat = transformLatWith(wgsLoc.longitude - 105, y: wgsLoc.latitude - 35)
//            var adjustLon =  transformLonWith(wgsLoc.longitude - 105, y: wgsLoc.latitude - 35)
//            var radLat = wgsLoc.latitude / 180.0 * pi
//            var magic = sin(radLat)
//            magic = 1 - ee * magic * magic
//            var sqrtMagic = sqrt(magic)
//            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
//            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
//            adjustLoc.latitude = wgsLoc.latitude + adjustLat
//            adjustLoc.longitude = wgsLoc.longitude + adjustLon
//        }
//        return adjustLoc;
//    }
//    
//    class func isLocationOutOfChina(location:CLLocationCoordinate2D)->Bool
//    {
//        if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
//        {
//            return true
//        }
//        return false
//    }
//    
//    class func transformLatWith(x:Double,y:Double)->Double
//    {
//        var p = 2.0 * x + 3.0 * y
//        p += 0.2 * y * y
//        p += 0.1 * x * y
//        p += 0.2 * sqrt(abs(x))
//        var lat = -100.0 + p
//        lat += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
//        lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
//        lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
//        return lat;
//    }
//    
//    class func transformLonWith(x:Double,y:Double)->Double
//    {
//        var lon = 300.0 + x + 2.0 * y
//        lon += 0.1 * x * x
//        lon += 0.1 * x * y
//        lon += 0.1 * sqrt(abs(x))
//        lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
//        lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
//        lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
//        return lon;
//    }  

}
