//
//  UserInfoVector.swift
//  ChatByDesiginPattern
//
//  Created by rolodestar on 2020/6/21.
//  Copyright © 2020 Rolodestar Studio. All rights reserved.
//

import Foundation
import AppKit

class UserInfoVector: MyBagVectorProtocol{
   
    
//    func reset() {
//        self.removeAll()
//    }
    
    
    func storiedBag(){
        if let results = load(){
            bags.removeAll()
            for  result in results{
                var bag :UserInfo = UserInfo()
                bag.bag = result.value(forKey: "bagData") as! Data
                bags.append(bag)
            }
        }
    }
    
    
    
    
    var enitityName: String?
    
    
    
    var delegate: MyBagVectorDelegate?
    
    var bags: [UserInfo]
    var usersInfo: [UserInfo]{
        get{
            let ui = UserInfo(name: "server", password: "", photo: UIImage(named: "boyHead") ?? UIImage())
            var rtBags : [UserInfo] = []
            rtBags.append(ui)
            for bag in bags{
                rtBags.append(bag)
            }
            return rtBags
        }
    }
    
    //typealias BAG = <#type#>
    
    typealias BAG = UserInfo
    private init(){
        bags = []
        enitityName =  "UserInfoVectorDatabase"
        storiedBag()
    }
    static let shared:UserInfoVector = UserInfoVector()
//    private static var _instanse: UserInfoVector? = nil
//    static func getShared() -> UserInfoVector{
//        if(_instanse == nil){
//            _instanse = UserInfoVector()
//        }
//        return _instanse!
//    }
    
}
