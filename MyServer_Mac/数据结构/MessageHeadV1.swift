//
//  MessageHeadV1.swift
//  TestMessage
//
//  Created by rolodestar on 2020/8/8.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate
class MessageHeadV1: NSObject,HeadProtocol{
    var json: JSON
    
    var bagType: BagType
    
    //var bagType: String
    
    var uuid: String
    
   
    
//    var contentDate: Data
    
    var contentType: MessageBodyType
    
    var headType: HeadType
    
    var headVersion: Int
    
    
    
    var contentEncoding: String.Encoding
    
    var contentSize: Int
    
    var contentDate: Date
    
    var bodyUuid: String
    
    func setJsonFromValue() {
        
        json = JSON()
        json["bagType"].stringValue = bagType.description
        json["uuid"].stringValue = uuid
        json["headType"].stringValue = headType.description
        
        json["headVersion"].intValue = headVersion
        json["contentEncoding"].uIntValue = contentEncoding.rawValue
        json["contentSize"].intValue = contentSize
        json["contentDate"].stringValue = contentDate.toString()
        json["bodyUuid"].stringValue = bodyUuid
        
    }
    
    func setValueFromJson(){
        bagType = BagType(from: json["bagType"].stringValue)
        headType = HeadType.init(from: json["headType"].stringValue)
        headVersion = json["headVersion"].intValue
        contentEncoding = String.Encoding(rawValue: json["contentEncoding"].uIntValue)
        contentSize = json["contentSize"].intValue
        contentDate = Date(json["contentDate"].stringValue) ?? Date()
        bodyUuid = json["bodyUuid"].stringValue
        uuid =  json["uuid"].stringValue
       
    }
    override init(){
        headType  = .request
        headVersion = 1
        contentType = .unknow
        contentEncoding = .utf8
        contentSize = 0
        bodyUuid = ""
        contentDate = Date()
        uuid = ""
        bagType = .messageHeadV1
        json = JSON()
        super.init()
        initUUID()
        setJsonFromValue()
        
    }
    init(by body: MessageBodyProtocol){
        headType  = .request
        headVersion = 1
        contentType = body.bodyType
        contentEncoding = body.stringEncoding
        let d = body.toData()
        
        contentSize = d.count
        bodyUuid = body.getValue(by: "uuid")?.stringValue ?? ""
        contentDate = Date()
        uuid = ""
        bagType = .messageHeadV1
        json = JSON()
        super.init()
        initUUID()
        setJsonFromValue()
    }
    
    
}
