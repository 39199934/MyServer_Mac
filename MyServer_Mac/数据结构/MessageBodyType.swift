//
//  MessageBodyType.swift
//  TestMessage
//
//  Created by rolodestar on 2020/8/8.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MessageBodyType: Int{
    case text
    case command
    case image
    case file
    case unknow
    static func getCount() -> Int{
        return 5
    }
    init(from string: String){
        switch string {
        case "text":
            self = .text
        case "command":
            self = .command
        case "image":
            self = .image
        case "file":
            self = .file
        default:
            self = .unknow
        }
    }
    init(from data: Data){
            do{
                let json = try JSON(data: data)
                let bagType = json["bodyType"].stringValue
                self.init(from: bagType)
         
            }catch{
                print(error.localizedDescription)
                self = .unknow
            }
        }
    var description: String{
        get{
            switch self {
       
            case .text:
                return "text"
            case .command:
                return "command"
            case .image:
                return "image"
            case .file:
                return "file"
            case .unknow:
                return "unknow"
                
            }
        }
    }
    static func parsingBag(from data: Data) -> BagProtocol?{
        let type = MessageBodyType.init(from: data)
        var rtBody: MessageBodyProtocol? = nil
        switch type {
        
        case .text:
            rtBody = TextBody()
            
        case .command:
            break
        case .image:
            rtBody = ImageBody()
            
        case .file:
            break
        case .unknow:
            break
        @unknown default:
            break
        }
        rtBody?.fromData(data: data)
        return rtBody
    }
}
