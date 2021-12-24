//
//  AnalyticsViewModel.swift
//  PLAccountingBook
//
//  Created by Paul on 2021/12/22.
//

import UIKit

class AnalyticsViewModel: NSObject {
    
    private(set) var recordData:[Record]!
    private(set) var tagData: [String]!
    
    override init(){
        super.init()
        updateProperty()
    }
    
    func updateProperty() {
        self.recordData = RecordManager.shared.query()
        self.tagData = TagManager.query()
    }
}
