//
//  InComeViewModel.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2022/8/4.
//

import UIKit

class InComeViewModel: NSObject {

    private(set) var recordData = [Record]()
    
    override init() {
        super.init()
        self.updateData()
    }
    
    func updateData() {
        self.recordData = RecordManager.shared.query().filter({$0.savingTypeId == 1 || $0.tag == "薪資"})
        
    }
    
}
