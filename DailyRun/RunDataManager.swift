//
//  RunDataManager.swift
//  MoonRunner
//
//  Created by randy on 15/8/14.
//  Copyright (c) 2015年 Zedenem. All rights reserved.
//

import Foundation
import Realm
class RunDataManager: NSObject {
    class var sharedInstance:RunDataManager
    {
        dispatch_once(&Inner.token)
            {
                Inner.instance = RunDataManager()
        }
        return Inner.instance!
    }
    struct Inner {
        static var instance: RunDataManager?
        static var token: dispatch_once_t = 0
    }
    
    var realm = RLMRealm.defaultRealm()

    func saveRunData(runData:RunData)
    {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        realm.addObject(runData)
        do
        {
            try realm.commitWriteTransaction()

        }
        catch
        {
            
        }
    }
    
    func updateRunData(runData:RunData)
    {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        do
        {
            try realm.commitWriteTransaction()
            
        }
        catch
        {
            
        }

    }
    
    func beginTransaction()
    {
        realm.beginWriteTransaction()
    }
    
    func endTransaction()
    {
        do
        {
            try realm.commitWriteTransaction()
            
        }
        catch
        {
            
        }

    }
    
    func totalMiles()->CGFloat
    {
        let results = RunData.allObjects()
        var totalMiles:CGFloat = 0.0
        for var i:UInt = 0;i < results.count;i++
        {
            let runData = results[i] as! RunData
            totalMiles += runData.distance
        }
        return totalMiles
    }

    func didUserRunToday()->Bool
    {
        let today = NSDate()
        let latestRecord = RunData.allObjects().lastObject() as? RunData
        if latestRecord == nil{
            return false
        }
        else
        {
            if Common.isSameDay(today, date2: latestRecord!.date)
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
    func todayRecord()->CGFloat
    {
        let zeroOclockDate = Common.todayAtZeroOclock()
        var totalDistanceToday:CGFloat = 0.0
        let results = RunData.objectsInRealm(self.realm, withPredicate: NSPredicate(format: "date > %@", zeroOclockDate))
        for var i:UInt = 0;i<results.count;i++
        {
            let runDataToday = results[i] as! RunData
            totalDistanceToday += runDataToday.distance
        }
        return totalDistanceToday
    }
}
