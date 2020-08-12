//
//  MySocket.swift
//  CocoaAsyncSocket
//
//  Created by rolodestar on 2020/6/15.
//

import Foundation
import CocoaAsyncSocket
import SwiftyJSON
import AppKit

class MySocket: GCDAsyncSocket{
     var clients:[GCDAsyncSocket] = []
    var statusLabel: NSTextField?
    var clientsList: NSTableView?
    let headSendedTAG: Int = 8011031
    let bodySendedTAG: Int = 8011032
    let readDataTAG: Int = 8011033
    let readDataLengthTAG: Int = 8011034
    let queue: DispatchQueue = DispatchQueue(label: "com.chatbyDesigin.delegateQueue")
    let socketQueue: DispatchQueue = DispatchQueue(label: "com.chatbyDesigin.socketQueue")
    var messageSendCatch: MessageBodyProtocol?
    var messages: MessageVector = MessageVector.shared
    var recvMsgCatch: [(head: HeadProtocol,body: MessageBodyProtocol?)] = []
    var hostAddress: String?{
        get{
            let setting = Setting.shared
            return setting.hostAddres
        }
    }
    var hostPort: UInt16?{
        get{
            let setting = Setting.shared
            return UInt16(setting.hostPort)
        }
    }
    var connectStateDescription: String{
        get{
            if isConnected{
                return "已连接"
            }  else{
                return "未连接"
            }
        }
    }
    static let shared = MySocket()
    convenience init(by socket: GCDAsyncSocket){
        
        
        self.init()
        
        
    }
    override init(delegate aDelegate: GCDAsyncSocketDelegate?, delegateQueue dq: DispatchQueue?, socketQueue sq: DispatchQueue?) {
        super.init(delegate: aDelegate, delegateQueue: dq, socketQueue: sq)
    }
    private init(){
    
        
        //connectedHost = "192.168.31.192"
        super.init(delegate: nil, delegateQueue: queue, socketQueue: socketQueue)
        self.delegate = self
        //hostAddress = "192.168.1.103"
        //hostPort = 5669
        //super.init(delegate: self, delegateQueue: queue)
        self.readData(withTimeout: -1, tag: readDataTAG)
    }
    func connectToHost(){
        if let add = hostAddress,let port = hostPort{
            do{
                try connect(toHost: add, onPort: port)
            }catch{
                debugPrint("connect to host error")
            }
        }
    }
    func sendMessage(message msg: MessageBodyProtocol){
        if(messageSendCatch == nil){
            messageSendCatch = msg
            messages.appendSend(newMessage: (head: msg.buildMessageHead(), body: msg) )
            // let tag = 10000000 * messageSendCatch.count + headSendedTAG
            let head = msg.buildMessageHead()
            write(head.toData(), withTimeout: -1, tag: headSendedTAG )
        }
    }
}

extension MySocket: GCDAsyncSocketDelegate{
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
    //        let mysocket = MySocket(by: socket)
            clients.append(newSocket)
            newSocket.delegate = self
            newSocket.delegateQueue = DispatchQueue.global()
            newSocket.readData(withTimeout: -1, tag: 1)
            DispatchQueue.main.async {
                self.statusLabel?.cell?.title = "有客户端连接"
                self.clientsList?.reloadData()
            }
            
            
        }
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        sock.readData(withTimeout: -1, tag: readDataTAG)
    }
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        if(tag == headSendedTAG){
            
            sock.write(messageSendCatch!.toData(), withTimeout: -1, tag: bodySendedTAG)
            
        }
        if(tag == bodySendedTAG){
            
            messageSendCatch = nil
            //sock.delegateQueue = socketQueue
        }
        
    }
    //    func socketdidread
    func appendBodyToReciveCatch(body: MessageBodyProtocol) -> Bool{
        for index in 0..<recvMsgCatch.count{
            if (recvMsgCatch[index].head.bodyUuid == body.uuid){
                recvMsgCatch[index] = (recvMsgCatch[index].head, body )
                messages.appendRecv(newMessage: (head: recvMsgCatch[index].head, body: body))
                return true
            }
        }
        return false
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        
        let str = String(data: data,encoding: Setting.shared.encoding)
        let type = BagType(from: data)
        let bag = type.parsingBag(from: data)
        switch type {
            
        case .messageHeadV1:
            let nmsg :(HeadProtocol,MessageBodyProtocol?) = (bag as! MessageHeadV1,nil)
            let head = bag as! MessageHeadV1
            let size = UInt(head.contentSize)
            recvMsgCatch.append(nmsg)
            sock.readData(toLength: size, withTimeout: -1, tag: readDataTAG)
            return
        case .body :
            let body = bag as! MessageBodyProtocol
            appendBodyToReciveCatch(body: body)
            
        case .unknow:
            let body = bag as! TextBody
            let head = body.buildMessageHead()
            //            recvMsgCatch.append((head: body.buildMessageHead(), body: body))
            messages.appendRecv(newMessage: (head: head, body: body))
        case .unFormatted:
            let body = bag as! TextBody
            let head = body.buildMessageHead()
            //            recvMsgCatch.append((head: body.buildMessageHead(), body: body))
            messages.appendRecv(newMessage: (head: head, body: body))
        default:
            break
            
        }
        
        
        sock.readData(withTimeout: -1, tag: readDataTAG)
    }
    
    
    
}
