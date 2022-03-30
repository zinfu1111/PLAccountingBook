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
        self.memberId = 0
    }
    
    internal init(id: Int? = nil,memberId: Int, content: String, cost: Double, tag: String, datetime: Date,status: Int? = nil) {
        self.id = id
        self.content = content
        self.cost = cost
        self.tag = tag
        self.datetime = datetime
        self.status = status
        self.memberId = memberId
    }
    
    
    
    let id:Int?
    var memberId:Int
    var content:String
    var cost:Double
    var tag:String
    var datetime:Date
    var status:Int?
    
    enum CodingKeys: CodingKey {
      case memberId, id, content, cost,tag,datetime,status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        memberId = try container.decode(Int.self, forKey: .memberId)
        content = try container.decode(String.self, forKey: .content)
        cost = try container.decode(Double.self, forKey: .cost)
        tag = try container.decode(String.self, forKey: .tag)
        if let date = try? container.decode(String.self, forKey: .datetime){
            datetime = date.toDate()
        }else{
            datetime = Date()
        }
        
        status = try? container.decode(Int.self, forKey: .status)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(datetime.toString(format: "YYYY-MM-dd HH:mm:ss"), forKey: .datetime)
        if id != nil {
            try container.encode(id, forKey: .id)
        }
        try container.encode(memberId, forKey: .memberId)
        try container.encode(content, forKey: .content)
        try container.encode(cost, forKey: .cost)
        try container.encode(tag, forKey: .tag)
        try container.encode(status, forKey: .status)
    }
    
    
}

