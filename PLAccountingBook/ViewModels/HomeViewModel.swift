//
//  HomeViewModel.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/1/4.
//

import UIKit

class HomeViewModel: NSObject {

    private(set) var recordData = [Record]()
    
    override init() {
        super.init()
        self.updateData()
    }
    
    func updateData() {
        self.recordData = RecordManager.shared.query().filter({ $0.datetime.toString(format: "yyyy/MM/dd") == Date().toString(format: "yyyy/MM/dd")})
        
    }
    
    func updateData(date: Date) {
        recordData = RecordManager.shared.query().filter({ $0.datetime.toString(format: "yyyy/MM/dd") == date.toString(format: "yyyy/MM/dd")})
    }
}
