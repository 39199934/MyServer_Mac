//
//  MessageBodyProtocol.swift
//  TestMessage
//
//  Created by rolodestar on 2020/8/8.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import SwiftyJSON
import CocoaAsyncSocket

let SENDHEADTAG = 80110301
let SENDBODYTAG = 80110302

protocol MessageBodyProtocol: BagProtocol {
    var bodyType: MessageBodyType{get set}
    var senderUuid: String{get set}
    var reciverUuid: String{get set}
    var description: String{get}
    
    
    
}
extension MessageBodyProtocol{
    var senderImage: NSImage? {
    
        return NSImage()
    }
    var description: String{
        return "message body protocol,type is:\(bodyType.description)"
    }
    func buildMessageHead() -> HeadProtocol{
        return MessageHeadV1(by: self)
        
    }
    func send(by socket: GCDAsyncSocket){
        DispatchQueue.global().async {
            let head = self.buildMessageHead()
            socket.write(head.toData(), withTimeout: -1, tag: SENDHEADTAG)
            
            usleep(50)
            socket.write(self.toData(), withTimeout: -1, tag: SENDBODYTAG)
            socket.readData(withTimeout: -1, tag: 1)
        }
        
        
    }
}
