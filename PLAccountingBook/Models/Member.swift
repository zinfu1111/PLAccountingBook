//
//  Member.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/14.
//

import Foundation

struct Member {
    
    internal init(id: Int, name: String, point: Int, phone: String) {
        self.id = id
        self.name = name
        self.point = point
        self.phone = phone
    }
    
    
    init(dataMO: MemberMO){
        self.id = Int(dataMO.id)
        self.name = dataMO.name ?? ""
        self.phone = dataMO.phone ?? ""
        self.point = Int(dataMO.point)
    }
    
    
    let id:Int
    var name:String
    var point:Int
    var phone:String
    
    
    
}
