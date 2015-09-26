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
        //let unitFlags = [.Year, .Month, .Day]
        let comp1 = calendar.components([.Year, .Month, .Day], fromDate:date1)
        let comp2 = calendar.components([.Year, .Month, .Day], fromDate:date2)
        return comp1.day == comp2.day &&
               comp1.month == comp2.month &&
               comp1.day == comp2.day
    }
    
    class func todayAtZeroOclock()->NSDate
    {
        let date = NSDate()
        let comp1 = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        let today = NSCalendar.currentCalendar().dateFromComponents(comp1)
        let comp2 = NSDateComponents()
        comp2.day = -1
        let yesterday = NSCalendar.currentCalendar().dateByAddingComponents(comp2, toDate: today!, options: [])
        let yesterdayComp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: yesterday!)
        let year = yesterdayComp.year
        let month = yesterdayComp.month
        let day = yesterdayComp.day
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = String(format: "%d-%d-%d 23:59:59",year,month,day)
        let zeroOclock = dateFormatter.dateFromString(dateString)
        print("tod:\(zeroOclock)")
        return zeroOclock!
    }
}
