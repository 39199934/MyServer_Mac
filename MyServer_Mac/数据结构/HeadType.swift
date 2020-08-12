//
//  HeadType.swift
//  ChatByDesiginPattern
//
//  Created by rolodestar on 2020/8/7.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
enum HeadType{
    case request
    case response
    case unknow
    init(from string: String){
        switch string {
        case "request":
            self = HeadType.request
        case "response":
            self = HeadType.response
        default:
            self = .unknow
        }
    }
    var description: String{
        get{
            switch self {
                
                
            case .request:
                return "request"
            case .response:
                return "response"
            case .unknow:
                return "unknow"
                
            }
        }
    }
}
