//
//  Setting.swift
//  ChatByDesiginPattern
//
//  Created by rolodestar on 2020/6/24.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import AppKit
import CoreData
class Setting{
    
    static let shared = Setting()
    
    var encoding: String.Encoding
    
    var selfInfo: UserInfo
    
    var hostAddres: String
    var hostPort:UInt
    var enitityName = "SettingDatabase"
    var context: NSManagedObjectContext = {
        let dele = NSApplication.shared.delegate as! AppDelegate
        let perContainer = dele.persistentContainer
        return perContainer.viewContext
    }()
    private init(){
        encoding = String.Encoding.utf8
        //encoding.raw
        selfInfo = UserInfo(login_name: "iphoneUser", login_password: "123456", user_photo: NSImage(named: "headBoy")!)
        hostAddres = "127.0.0.1"
        hostPort = 5668
//        load()
    }
    
    deinit {
//        save()
    }
    
    func load() -> [NSManagedObject]{
        
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: enitityName)
        do{
            let results = try context.fetch(request) as! [NSManagedObject]
            if(results.count >= 1){
                let result = results[0]
                encoding = String.Encoding(rawValue: result.value(forKey: "encoding") as! UInt)
                //var ui = UserInfo()
                let uiData = result.value(forKey: "selfInfo") as! Data
                self.selfInfo.fromData(data:  uiData)
                hostAddres = result.value(forKey: "hostAddress") as! String
                hostPort = result.value(forKey: "hostPort") as! UInt
                
            }else{
                encoding = String.Encoding.utf8
                //encoding.raw
                selfInfo = UserInfo(login_name: "iphoneUser", login_password: "123456", user_photo: NSImage(named: "headBoy")!)
                hostAddres = "127.0.0.1"
                hostPort = 5668
                save()
            }
            return results
        }catch{
            return []
        }
    }
    func save(){
        guard let entity = NSEntityDescription.entity(forEntityName: enitityName, in: context) else { return  }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: enitityName)
        do{
            let results = try context.fetch(request) as! [NSManagedObject]
            for result in results{
                context.delete(result)
            }
            let obj = NSManagedObject(entity: entity, insertInto: context)
            obj.setValue(encoding.rawValue, forKey: "encoding")
            obj.setValue(selfInfo.toData(), forKey: "selfInfo")
            obj.setValue(hostAddres, forKey: "hostAddress")
            obj.setValue(hostPort, forKey: "hostPort")
            try context.save()
            
        }catch{
            return
        }
    }
}
