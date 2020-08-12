//
//  BagType.swift
//  TestMessage
//
//  Created by rolodestar on 2020/8/8.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import SwiftyJSON
enum BagType{
    case messageHeadV1
    case body
    case userInfo
//    case imageBody
    
    case unknow
    case unFormatted
    
    var description: String{
        get{
            switch self {
                
                
            case .messageHeadV1:
                return "messageHeadV1"
                
            case .body:
                return "body"
//                case .imageBody:
//                return "imageBody"
            case .userInfo:
                return "userInfo"
            case .unknow:
                //rtBag = TextBody()
                return "unknow"
            case .unFormatted:
                return "unFormatted"
                
            }
        }
    }
    init(from strDescription: String){
        switch strDescription {
        case "messageHeadV1":
            self = .messageHeadV1
        case "body":
            self = .body
//            case "imageBody":
//            self = .imageBody
        case "userInfo":
            self = .userInfo
        case "unknow":
            self = .unknow
        default:
            self = .unFormatted
        }
    }
    init(from data: Data){
        do{
            let json = try JSON(data: data)
            let bagType = json["bagType"].stringValue
            self.init(from: bagType)
//            switch bagType {
//            case "messageHeadV1":
//                self = .messageHeadV1
//            case "body":
//                self = .body
//                case "imageBody":
//                           self = .imageBody
//            case "userInfo":
//                self = .userInfo
//            case "unknow":
//                self = .unknow
//            default:
//                self = .unFormatted
//                //return nil
            
        }catch{
            print(error.localizedDescription)
            self = .unFormatted
        }
    }
    func parsingBag(from data: Data) -> BagProtocol?{
        var rtBag: BagProtocol
        
        switch self {
       
      
        case .messageHeadV1:
            rtBag = MessageHeadV1()
            
        case .body:
            return MessageBodyType.parsingBag(from: data)
        case .unknow:
            //rtBag = TextBody()
            let str = String(data: data, encoding: String.Encoding.utf8) ?? "unwrap data fault"
            rtBag = TextBody(from: "0", to: "0", message: str)
            return rtBag
        case .unFormatted:
            let str = String(data: data, encoding: String.Encoding.utf8) ?? "unwrap data fault"
            rtBag = TextBody(from: "0", to: "0", message: str)
            return rtBag
        
        case .userInfo:
            rtBag = UserInfo()
        }
        rtBag.fromData(data: data)
        return rtBag
        
    }
}
