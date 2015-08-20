//
//  AqiObject.swift
//  DailyRun
//
//  Created by randy on 15/8/20.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class AqiObject: NSObject {
    var aqi:Int?
    var level:String?
    var city:String?
    var aqiIcon:UIImage?
    init(aqi:Int,level:String,city:String,aqiIcon:UIImage?) {
        super.init()
        self.aqi = aqi
        self.city = city
        self.level = level
        self.aqiIcon = aqiIcon
    }

}
