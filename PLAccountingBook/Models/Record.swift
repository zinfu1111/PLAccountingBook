//
//  Record.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import Foundation

struct Record:Codable {
    
    init(dataMO: RecordMO){
        self.id = Int(dataMO.id)
        self.content = dataMO.content ?? ""
        self.cost = dataMO.cost
        self.tag = dataMO.tag ?? ""
        self.datetime = dataMO.datetime ?? Date()
    }
    
    internal init(id: Int? = nil, content: String, cost: Double, tag: String, datetime: Date) {
        self.id = id
        self.content = content
        self.cost = cost
        self.tag = tag
        self.datetime = datetime
    }
    
    
    let id:Int?
    var content:String
    var cost:Double
    var tag:String
    var datetime:Date
    
}
