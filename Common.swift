//
//  Common.swift
//  DailyRun
//
//  Created by randy on 15/8/18.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import Foundation
class Common:NSObject
{
    class func isSameDay(date1:NSDate,date2:NSDate)->Bool
    {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth |  NSCalendarUnit.CalendarUnitDay
        let comp1 = calendar.components(unitFlags, fromDate: date1)
        let comp2 = calendar.components(unitFlags, fromDate:date2)
        return comp1.day == comp2.day &&
               comp1.month == comp2.month &&
               comp1.day == comp2.day
    }
    
    class func todayAtZeroOclock()
    {
        let localzone = NSTimeZone.localTimeZone()
        let GTMzone = NSTimeZone(forSecondsFromGMT: 0)
        let unitFlags = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth |  NSCalendarUnit.CalendarUnitDay
        let today = NSDate()
        let zone = NSTimeZone.localTimeZone()
        let interval = zone.secondsFromGMTForDate(today)
        let localeDate = today.dateByAddingTimeInterval(NSTimeInterval(interval))
        let comp1 = NSCalendar.currentCalendar().components(unitFlags, fromDate: localeDate)
        let year = comp1.year
        let month = comp1.month
        let day = comp1.day
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = GTMzone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = String(format: "%d-%d-%d 23:59:59",year,month,day)
        let zeroOclock = dateFormatter.dateFromString(dateString)
        let dateAtZone = NSDate(timeInterval: 3600, sinceDate: zeroOclock!)
        dateFormatter.timeZone = localzone
        println("tod:\(dateAtZone)")
    }
}
