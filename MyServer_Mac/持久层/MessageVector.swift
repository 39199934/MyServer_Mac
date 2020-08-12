//
//  MessageVector.swift
//  ChatByDesiginPattern
//
//  Created by rolodestar on 2020/6/15.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Notification.Name{
    static let newMessageAppend = Notification.Name("new MessageAppend")
    static let newSendMessageAppend = Notification.Name("new Send MessageAppend")
    static let newRecvMessageAppend = Notification.Name("new Recv MessageAppend")
}

protocol MessageVectorDelegate {
    func mvAppendedNewMessage(msg: (head: HeadProtocol,body: MessageBodyProtocol))
}

protocol MessageVectorProtocol{
    var delegate: MessageVectorDelegate?{get set}
    var messages: [(head: HeadProtocol,body: MessageBodyProtocol)]{get set}
    var heads: [HeadProtocol]{get set}
    var bodys: [MessageBodyProtocol]{get set}
    func append(newMessage: (head: HeadProtocol,body: MessageBodyProtocol))
    func appendSend(newMessage: (head: HeadProtocol,body: MessageBodyProtocol))
    func appendRecv(newMessage: (head: HeadProtocol,body: MessageBodyProtocol))
   // func append(newData: Data)
    func save()
    func load()
   
    
    
}




class MessageVector: MessageVectorProtocol{
    
    var delegate: MessageVectorDelegate?
    
    
    
    func save() {
        
    }
    
    func load() {
        
    }
    
   
    
    
    var messages: [(head: HeadProtocol,body: MessageBodyProtocol)]
    var heads: [HeadProtocol]
    var bodys: [MessageBodyProtocol]
    private init(){
        messages = []
        heads = []
        bodys = []
        //_instace = nil
    }
    func append(newMessage: (head: HeadProtocol,body: MessageBodyProtocol)){
        messages.append(newMessage)
        delegate?.mvAppendedNewMessage(msg: newMessage)
        NotificationCenter.default.post(name: .newMessageAppend,object: nil)
    }
    func appendSend(newMessage: (head: HeadProtocol,body: MessageBodyProtocol)){
        append(newMessage: newMessage)
        
        NotificationCenter.default.post(name: .newSendMessageAppend,object: nil)
    }
    func appendRecv(newMessage: (head: HeadProtocol,body: MessageBodyProtocol)){
        append(newMessage: newMessage)
        
        NotificationCenter.default.post(name: .newRecvMessageAppend,object: nil)
    }
//    func append(newData: Data){
//        let dataParsing = BagParsing(from: newData)
//        if let head = dataParsing.head{
//            heads.append(head)
//        }
//        else if let body = dataParsing.body{
//            bodys.append(body)
//            let bUuid = body.uuid
//            if let h = takeHead(by: bUuid){
//                let msg = Message(new_head: h, new_body: body)
//                self.append(newMessage: msg)
//            }
//
//        }
//        else if let unKonwMsg = dataParsing.unKnowMessage{
//            append(newMessage: unKonwMsg)
//        }
//    }
    static var shared: MessageVector = MessageVector()
    /*static func getShared() -> MessageVector{
        if(_instace == nil){
            _instace = MessageVector()
        }
        return _instace!
    }*/
    
//    func takeHead(by bodyUuid: String) -> HeadProtocol?{
//        for i in 0 ..< heads.count{
//            if heads[i].bodyUuid == bodyUuid{
//                let h = heads[i]
//                heads.remove(at: i)
//                return h
//            }
//        }
//        return nil
//    }
    func getMessage(by userId:String) -> [(head: HeadProtocol,body: MessageBodyProtocol)]{
        var rtMsg : [(head: HeadProtocol,body: MessageBodyProtocol)] = []
        for msg in messages{
            if(msg.body.senderUuid == userId || msg.body.reciverUuid == userId || (msg.body.senderUuid.isEmpty && msg.body.senderUuid.isEmpty)){
                rtMsg.append(msg)
            }
        }
        return rtMsg
    }
}
