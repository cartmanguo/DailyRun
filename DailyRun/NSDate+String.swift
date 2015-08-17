//
//  NSDate+String.swift
//  Iot
//
//  Created by randy on 15/5/21.
//  Copyright (c) 2015年 GuoCheng. All rights reserved.
//

import Foundation
extension NSDate
{
    var dateString:String?
    {
        get
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.stringFromDate(self)
        }
    }
    
    var shortDateString:String?
    {
        get
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.stringFromDate(self)
        }
    }
    
    var yearDateString:String?
    {
        get
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate(self)
        }
    }
    
    class func ISO8601DateToUTCDate(iso8601dateString:String)->NSDate?
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // Always use this locale when parsing fixed format date strings
        let posix = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = posix
        let utcDate = dateFormatter.dateFromString(iso8601dateString)
        return utcDate
    }
}
