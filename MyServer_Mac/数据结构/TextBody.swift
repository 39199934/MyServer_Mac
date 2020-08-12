//
//  TextBody.swift
//  TestMessage
//
//  Created by rolodestar on 2020/8/8.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import SwiftyJSON

class TextBody: NSObject,MessageBodyProtocol{
    var json: JSON
    
    var bagType: BagType
    
    
    
    var bodyType: MessageBodyType
    
    
    
    var senderUuid: String
    
    var reciverUuid: String
    
    var uuid: String
    var text: String
    override var description: String{
        return text
    }
    
    func setJsonFromValue() {
//        json..remove
//        json = JSON()
         json["bagType"].stringValue = bagType.description
        json["uuid"].stringValue = uuid
        json["bodyType"].stringValue = bodyType.description
        
        json["senderUuid"].stringValue = senderUuid
        json["reciverUuid"].stringValue = reciverUuid
        json["text"].stringValue = text
        
    }
    
    func setValueFromJson() {
        bagType = BagType(from: json["bagType"].stringValue)
        uuid = json["uuid"].stringValue
        bodyType = MessageBodyType(from: json["bodyType"].stringValue)
        senderUuid = json["senderUuid"].stringValue
        reciverUuid = json["reciverUuid"].stringValue
        text = json["text"].stringValue
    }
    override init(){
        bagType = .body
        bodyType = .text
        senderUuid = ""
        reciverUuid = ""
        uuid = ""
        text = ""
        json = JSON()
        super.init()
        initUUID()
        setJsonFromValue()
    }
    init(from senderUUID: String, to reciverUUID: String,message txt: String ){
        json = JSON()
        bagType = .body
        bodyType = .text
        senderUuid = senderUUID
        reciverUuid = reciverUUID
        uuid = ""
        text = txt
        super.init()
        initUUID()
        setJsonFromValue()
    }
    
}
