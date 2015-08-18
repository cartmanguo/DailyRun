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
}
