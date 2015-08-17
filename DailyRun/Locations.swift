//
//  Locations.swift
//  MoonRunner
//
//  Created by randy on 15/8/14.
//  Copyright (c) 2015年 Zedenem. All rights reserved.
//

import Foundation
import Realm
class Locations: RLMObject {
    dynamic var latitude:Double = 0.0
    dynamic var longitude:Double = 0.0
    dynamic var timestamp = NSDate()
}
