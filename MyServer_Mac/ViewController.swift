//
//  ViewController.swift
//  MyServer_Mac
//
//  Created by rolodestar on 2020/8/9.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Cocoa
import CocoaAsyncSocket
import SwiftyJSON

class ViewController: NSViewController {
    var socket = MySocket.shared
    //var clients:[GCDAsyncSocket]!
    var jsonBody: MessageBodyProtocol? = nil
    var jsonHead: HeadProtocol? = nil
    @IBOutlet weak var cLabel: NSTextField!
    @IBOutlet weak var cReciveHistory: NSTextField!
    @IBOutlet weak var cSendHistory: NSTextField!
    @IBOutlet weak var cSendText: NSTextField!
    
    @IBOutlet weak var cClientList: NSTableView!
   
    @IBOutlet weak var cJsonBody: NSTextField!
    @IBOutlet weak var cKey: NSTextField!
    @IBOutlet weak var cValue: NSTextField!
    @IBOutlet weak var cMessageType: NSComboBox!
    @IBOutlet weak var cJsonHead: NSTextField!
    @IBOutlet weak var cImageView: NSImageView!
    
    @IBAction func onClickedRefresh(_ sender: Any) {
        if let body = jsonBody{
            jsonHead = body.buildMessageHead()
            let bStr = body.json.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)
            let hStr = jsonHead?.json.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)
            cJsonHead.cell?.title = hStr  ?? ""
            cJsonBody.cell?.title = bStr ?? ""
        }
    }
    
    @IBAction func onClickedSave(_ sender: Any) {
        if let str = cJsonBody.cell?.title{
            jsonBody?.json = JSON.init(parseJSON: str)
                
            jsonBody?.setValueFromJson()
            onClickedRefresh(jsonBody)
        }
    }
    @IBAction func onClickedInsert(_ sender: Any) {
        if let k = cKey.cell?.title ,let v = cValue.cell?.title{
            jsonBody?.json[k].stringValue = v
            jsonBody?.setValueFromJson()
            onClickedRefresh(jsonBody)
        }
    }
    @IBAction func onClickedSendJson(_ sender: Any) {
        if let msg = jsonBody{
            for c in socket.clients{
                
                //            c.write(msg.toData(), withTimeout: -1, tag: 1)
                msg.send(by: c)
                //c.write(data, withTimeout: -1, tag: 1)
            }
            appendSend(str: msg.description)
            if msg.bodyType == .image{
                let nb = msg as! ImageBody
                DispatchQueue.main.async {
                    self.cImageView.image = nb.image
                }
                
            }
        }
        
        
        
        
    }
    @IBAction func onClickedBuildHead(_ sender: Any) {
    }
    
    @IBAction func onClickedInit(_ sender: Any) {
        let index = cMessageType.indexOfSelectedItem
        if let type = MessageBodyType.init(rawValue: index){
            switch type {
            
            case .text:
                if let str = cSendText.cell?.title{
                    let textBody = TextBody(from: "server", to: "client", message: str)
                    jsonBody = textBody
                    onClickedRefresh(cJsonBody)
                }
            case .command:
                break
            case .image:
                if let img = NSImage(named: "headBoy"){
                    let imageBody = ImageBody(from: "server", to: "client", image: img)
                    jsonBody = imageBody
                    onClickedRefresh(cJsonBody)
                }
            case .file:
                break
            case .unknow:
                break
            @unknown default:
                break
            }
        }
        
        
    }
    
    @IBOutlet weak var cBtnAccept: NSButton!
    @IBAction func onClickedAccept(_ sender: Any) {
        do{
               let rt = try socket.accept(onPort: 5668)
                   print(rt)
            self.cLabel.cell?.title = "服务器已开启"
               }catch{
                   print(error.localizedDescription)
               }
    }
    @IBAction func onClickedRefreshClients(_ sender: Any) {
        cClientList.reloadData()
    }
    
    @IBAction func onClickedSend(_ sender: NSButton) {
        if let txt = cSendText.cell?.title {
            let msg = TextBody(from: "server", to: "client", message: txt)
            jsonBody = msg
            
            //let data = txt.data(using: String.Encoding.utf8)
            for c in socket.clients{
        
//            c.write(msg.toData(), withTimeout: -1, tag: 1)
            msg.send(by: c)
            //c.write(data, withTimeout: -1, tag: 1)
        }
            appendSend(str: txt)
        }
    }
    
    func appendSend(str: String){
        cSendHistory.cell?.title += "\n\(Date().toString())\n\(str)\n"
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.statusLabel = cLabel
        socket.clientsList = cClientList
        cJsonHead.isEnabled = false
//        clients = []
//        socket.delegate = self
//        socket.delegateQueue = DispatchQueue(label: "com.myserver.ro")
        self.cLabel.cell?.title = "服务器未开启"
        cClientList.delegate = self
        cClientList.dataSource = self
//        socket.acc
//        cImageView.cell.im
        cMessageType.removeAllItems()
        for i in 0..<MessageBodyType.getCount(){
            let ty = MessageBodyType.init(rawValue: i)
            cMessageType.addItem(withObjectValue: ty?.description)
        }
        
       
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(onNewRecv), name: NSNotification.Name.newRecvMessageAppend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNewSend), name: NSNotification.Name.newSendMessageAppend, object: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @objc func onNewRecv(){
        
        guard let msg = MessageVector.shared.messages.last else{
            return
        }
        let head = msg.head
        let body = msg.body
        if body.bodyType == .image{
            let nb = body as! ImageBody
            DispatchQueue.main.async {
                self.cImageView.image = nb.image
            }
            
//            let alert = NSAlert()
//
//            
//            let image = nb.image
//            alert.icon = image
//            alert.alertStyle = .informational
//            alert.beginSheetModal(for: view.window!) { (reps) in
//                return
//            }
        }
        DispatchQueue.main.async {

            
            self.cReciveHistory.cell?.title += "\r\n head:\n \(head.json.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted) ?? "") \n body:\n \(body.description)"
//            self.cReciveHistory.scrollToEndOfDocument(nil)
        }
        
    }
    @objc func onNewSend(){
        guard let msg = MessageVector.shared.messages.last else{
                   return
               }
               let head = msg.head
               let body = msg.body
               DispatchQueue.main.async {

                   
                   self.cSendHistory.cell?.title += "\r\n head:\n \(head.json.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted) ?? "") \n body:\n \(body.description)"
               }
        
    }


}
extension ViewController: GCDAsyncSocketDelegate{
//    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
////        let mysocket = MySocket(by: socket)
////        clients.append(newSocket)
//        newSocket.delegate = self
//        newSocket.delegateQueue = DispatchQueue.global()
//        newSocket.readData(withTimeout: -1, tag: 1)
//        DispatchQueue.main.async {
//            self.cLabel.cell?.title = "有客户端连接"
//            self.cClientList.reloadData()
//        }
//
//
//    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let txt = String(data: data, encoding: .utf8) {
            let bagtype = BagType(from: data)
            DispatchQueue.main.async {

                
                self.cReciveHistory.cell?.title += "\r\n \(txt) "
            }
        }
        
        sock.readData(withTimeout: -1, tag: 1)
    }
    
}
extension ViewController: NSTableViewDataSource,NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return socket.clients.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView.tableColumns[0] != tableColumn{
            return nil
        }
        let soc = socket.clients[row]
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else
        {
            return nil
            
        }
//        let addressStr = soc.connectedAddress?.withUnsafeBytes({ (p) -> String? in
//            let family = p.baseAddress?.assumingMemoryBound(to: sockaddr_storage.self).pointee.ss_family
//            if family == numericCast(AF_INET){
//                return String(p.baseAddress?.assumingMemoryBound(to: sockaddr_in.self).pointee.sin_addr ?? <#default value#>)
//            }else if family == numericCast(AF_INET6){
//
//            }
//        })
        let ad = String(data: soc.connectedAddress ?? Data(), encoding: String.Encoding.utf8) ?? ""
        cell.textField?.stringValue = "\(row + 1):\(ad)\(soc.connectedPort)"
        
        return cell
//        let c  = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IdListCell"), owner: nil)
//        if let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: "IdListCell"), owner: self) as? NSTableCellView
//        {
//
//        cell.textField?.stringValue = "\(row + 1):\(soc.connectedAddress?.toHexString())\(soc.connectedPort)"
//        return cell
//        }
//        return nil
    }
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        let soc = clients[row]
//        return "\(row + 1):\(soc.connectedAddress?.toHexString())\(soc.connectedPort)"
//    }
}
