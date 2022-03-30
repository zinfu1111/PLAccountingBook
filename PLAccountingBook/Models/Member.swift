//
//  Member.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/14.
//

import Foundation

var userId = ""
struct Member:Codable {
    
    internal init(id: Int? = nil, name: String, point: Int, phone: String, mail: String) {
        self.id = id
        self.name = name
        self.point = point
        self.phone = phone
        self.mail = mail
    }
    
    
    init(dataMO: MemberMO){
        self.id = Int(dataMO.id)
        self.name = dataMO.name ?? ""
        self.phone = dataMO.phone ?? ""
        self.point = Int(dataMO.point)
        self.mail = dataMO.mail ?? ""
    }
    
    
    let id:Int?
    var name:String
    var point:Int
    var phone:String
    var mail:String
    
}
