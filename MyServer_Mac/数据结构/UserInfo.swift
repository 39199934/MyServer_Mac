//
//  UserInfo.swift
//  ChatByDesiginPattern
//
//  Created by rolodestar on 2020/6/21.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//
/*
 用户信息
 应包含以下信息
 用户名
 密码
 照片
 uuid
 
 */

import Foundation
import AppKit
import SwiftyJSON
import CryptoSwift
class UserInfo: NSObject ,BagProtocol{
    var json: JSON
    
    var bagType: BagType
    
   
    var uuid: String
    
    var loginName: String
    var password: String
    var nickName: String
    var photoData: Data
    
    var photo: NSImage?{
        get{
            return  NSImage(data: photoData)
        }
        set{
            photoData = newValue?.tiffRepresentation ?? Data()
        }
    }
    
    var token: String{
        get{
            let hmac = try! HMAC(key: password, variant: HMAC.Variant.sha256).authenticate(loginName.bytes)
            return hmac.toHexString()
        }
    }
    
    
    func setJsonFromValue() {
        json = JSON()
        json["bagType"].stringValue = bagType.description
        json["uuid"].stringValue = uuid
        json["loginName"].stringValue = loginName
        
        json["password"].stringValue = password
        json["photoData"].stringValue = photoData.base64EncodedString()
        json["nickName"].stringValue = nickName
        
    }
    
    func setValueFromJson() {
        bagType = BagType.init(from:  json["bagType"].stringValue)// = bagType.description
        uuid = json["uuid"].stringValue
        loginName = json["loginName"].stringValue
        
        password = json["password"].stringValue
        photoData = Data(base64Encoded: json["photoData"].stringValue) ?? Data() // = photoData.base64EncodedString()
        nickName = json["nickName"].stringValue
    }
    
  
    
//    var name: String{
//        get{
//            return getValue(by: "name")?.stringValue ?? "unknowName"
//        }
//        set{
//
//            insert { ( json) -> JSON in
//                json["name"].stringValue = newValue
//                return json
//            }
//            //insert(by: "name", value: JSON(stringLiteral: newValue))
//        }
//    }
//    var password: String{
//        get{
//            return getValue(by: "password")?.stringValue ?? ""
//        }
//        set{
//            insert { ( json) -> JSON in
//                json["password"].stringValue = newValue
//                return json
//            }
//            //insert(by: "password", value: JSON(stringLiteral: newValue))
//        }
//    }
//    var photo: NSImage{
//        get{
//            do{
//                let  dataString = try  getValue(by: "photo")?.stringValue ?? ""
//                let data = Data(base64Encoded: dataString) ?? Data()//dataString?.data(using: String.Encoding.ascii) ?? Data()
//                return NSImage(data: data) ?? NSImage()
//            }catch{
//                return NSImage()
//            }
//        }
//        set{
//
//                insert { ( json) -> JSON in
//                    let data = newValue.pngData() ?? Data()
//                    let dataString = data.base64EncodedString()
//                    //let dataString = String(data: newValue.pngData() ?? Data(), encoding: String.Encoding.ascii) ?? ""
//                    json["photo"].stringValue = dataString
//                    return json
//            }
////                }
////                //try insert(by: "name", value: JSON(data:  newValue.pngData() ?? Data()))
////            }catch{
////                insert(by: "photo", value: )
////            }
//        }
//    }
    init(login_name: String,login_password: String,user_photo: NSImage){
        json = JSON()
        bagType = .userInfo
        loginName = login_name
        password = login_password
        uuid = ""
        nickName = ""
        photoData = Data()
        super.init()
        photo = user_photo
        initUUID()
        setJsonFromValue()
        
        
    }
    convenience init(login_name: String,login_password: String){
        self.init(login_name: login_name,login_password: login_password,user_photo: NSImage())
    }
    convenience override init(){
        self.init(login_name: "",login_password: "",user_photo: NSImage())
        
    }
}
