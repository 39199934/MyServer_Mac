//
//  HeadProtocol.swift
//  ChatByDesiginPattern
//
//  Created by rolodestar on 2020/8/7.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation

protocol HeadProtocol: NSObject,BagProtocol {
    var headType: HeadType{get set}
    var headVersion: Int{get set}
    var contentType: MessageBodyType { get set }
//    var contentCharset: String { get set }
    var contentEncoding: String.Encoding {get set}
    var contentSize: Int{get set}
    var contentDate: Date{get set}
    var bodyUuid: String{get set}
}
