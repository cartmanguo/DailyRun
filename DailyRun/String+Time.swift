//
//  String+Time.swift
//  MoonRunner
//
//  Created by randy on 15/7/30.
//  Copyright (c) 2015年 Zedenem. All rights reserved.
//

import Foundation
extension Int
{
    var timeFormatted:String
    {
        let seconds = self % 60;
        let minutes = (self / 60) % 60;
        let hours = self / 3600;
        return NSString(format: "%02d:%02d:%02d", hours, minutes, seconds) as String
    }

}