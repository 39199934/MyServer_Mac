//
//  BagProtocol.swift
//  ChatByDesiginPattern
//
//  Created by rolodestar on 2020/6/11.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import SwiftyJSON
import AppKit


protocol BagProtocol : NSObject{
    var bagType : BagType{get set}
    var json: JSON{get set}
    var uuid: String{get set}
    func setJsonFromValue()
    func setValueFromJson()
   
   
//    var uuid: String{get set}
//
//    mutating func setBagFrom(json data: JSON)
//    func getJson() -> JSON?
//
//
//    //mutating func insert(by key: String,value: JSON)
//    mutating func insert(method: ( _ getjson : inout JSON) -> JSON)
//    mutating func remove(by key: String)
//     mutating func replace(method: ( _ getjson: inout JSON) -> JSON)
//    //mutating func replace(by key: String,value: Any)
//    func getValue(by key: String) -> JSON?
//    mutating func initUUID()
    
    
    
//    func getUuid() ->String
//    mutating  func setUuid(new uuid: String)
//
    
    
}
extension BagProtocol{
//    var json: JSON   //{
//        get{
//            return self.json
//        }
//        set{
//            self.json = newValue
//            setValueFromJson()
//        }
//    }
    var stringEncoding :String.Encoding{
        get{
            return String.Encoding.utf8
        }
    }
    func toData() -> Data{
        setJsonFromValue()
        do{
            let data = try json.rawData()
            return data
        }catch{
            return Data()
        }
    }
    func fromData(data: Data){
        do{
            let newjson = try JSON(data: data)
            if newjson.isEmpty{
                return
            }
            json = newjson
            setValueFromJson()
            
            
        }catch{
            
        }
    }
    
    func initUUID() {
        let uuid = UUID()
        self.uuid = uuid.uuidString
       
       
        
    }
    func getValue(by key: String) -> JSON?{
      
           
            return json[key]
       
    }
    func remove(by key: String){
        
        if var dicObj = json.dictionaryObject{
        
            dicObj.removeValue(forKey: key)
            json = JSON(dicObj)
            
            
        }
    }
//    mutating func setBagFrom(json data: JSON){
//        do{
//
//            let jData: Data = try data.rawData()//(options: JSONSerialization.WritingOptions.prettyPrinted)
//            bag = jData
//        }catch{
//            bag = Data()
//        }
//    }
//    func getJson() -> JSON?{
//        do{
//
//            let json = try JSON(data: bag) //JSON(data: Data, options: JSONSerialization.ReadingOptions.)
//            return json
//
//        }catch{
//            return nil
//        }
//    }
//     func insert(method: ( _ getjson: inout JSON) -> JSON){
//
//
//            let newj = method(&json)
//            setBagFrom(json: newj)
//
//        }else{
//            var j = JSON()
//            let newj = method(&j)
//            setBagFrom(json: newj)
//        }
//
//
//
//        //json![key].object  = value
//
//    }
//
//    func replace(method: ( _ getjson: inout JSON) -> JSON){
//
//           if var  json = getJson() {
//               let newj = method(&json)
//               setBagFrom(json: newj)
//
//           }else{
//               var j = JSON()
//               let newj = method(&j)
//               setBagFrom(json: newj)
//           }
//
//
//
//           //json![key].object  = value
//
//       }
///*
//    mutating func insert(by key: String,value: JSON){
//        var  json = getJson()
//        if json != nil{
//            json![key] = value
//            //json![key].object  = value
//            setBagFrom(json: json!)
//        }else{
//            var nj = JSON()
//            nj[key] = value
//            setBagFrom(json: nj)
//        }
//    }*/
    
    /*
    mutating func replace(by key: String,value: Any){
        if var json = getJson(){
            json[key] = JSON(value)
            setBagFrom(json: json)
        }else{
            var j = JSON()
            j[key].object = JSON(value)
            setBagFrom(json: j)
        }
        
    }*/
    
    
//    func getUuid() ->String{
//        if let value = getValue(by: "uuid"){
//            return value.stringValue
//
//        }
//        return ""
//    }
    //    mutating  func setUuid(new uuid: String){
    //        replace(by: "uuid", value: uuid)
    //    }
    
//    var uuid: String{
//        get{
//            if let value = getValue(by: "uuid"){
//                return value.stringValue
//
//            }
//            return ""
//        }
//        set{
//            replace { (json) -> JSON in
//                json["uuid"].stringValue = newValue
//                return  json
//            }
//            //replace(by: "uuid", value: newValue)
//        }
//
//    }
//    var  bagType:  BagType{
//        get{
//            if let value = getValue(by: "bagType"){
//                return BagType.init(rawValue: value.stringValue) ?? BagType.unKnow
//
//            }
//            return .unKnow
//        }
//        set{
//            replace { (json) -> JSON in
//                json["bagType"].stringValue = newValue.description
//                return  json
//            }
//            //replace(by: "bagType", value: newValue.description)
//        }
//    }
    
    
}
