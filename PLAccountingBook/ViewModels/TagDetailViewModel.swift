//
//  TagDetailViewModel.swift
//  PLAccountingBook
//
//  Created by User on 2022/1/17.
//

import UIKit

class TagDetailViewModel : NSObject {
    
    private(set) var record:[Record]!
    private(set) var tag: String!
    
    
    init(tag:String,date:Date) {
        self.tag = tag
        self.record = RecordManager.shared.query().filter({$0.tag == tag && $0.datetime.toString(format: "yyyy.MM") == date.toString(format: "yyyy.MM")})
    }
    
}
