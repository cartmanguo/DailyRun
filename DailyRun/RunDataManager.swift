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
        realm.commitWriteTransaction()
    }
    
    func updateRunData(runData:RunData)
    {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        realm.commitWriteTransaction()
    }
    
    func beginTransaction()
    {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
    }
    
    func endTransaction()
    {
        let realm = RLMRealm.defaultRealm()
        realm.commitWriteTransaction()
    }

}
