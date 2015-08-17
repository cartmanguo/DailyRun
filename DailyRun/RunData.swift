//
//  RunData.swift
//  MoonRunner
//
//  Created by randy on 15/8/14.
//  Copyright (c) 2015年 Zedenem. All rights reserved.
//

import Foundation
import UIKit
import Realm
class RunData: RLMObject {
    dynamic var distance:CGFloat = 0.0
    dynamic var date = NSDate(timeIntervalSince1970: 1)
    dynamic var duration = 0
    dynamic var pace = 0.0
    dynamic var note = ""
    dynamic var locations = RLMArray(objectClassName: "Locations")
}
