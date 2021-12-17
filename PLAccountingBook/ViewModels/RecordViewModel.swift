//
//  RecordViewModel.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import UIKit

class RecordViewModel: NSObject,DatePickerViewDelegate {

    private(set) var recordData = [Record]()
    var selectedDateClosure = {}
    
    override init() {
        super.init()
        self.recordData = RecordManager.shared.query()
    }
    
    
    func selected(_ datepicker: UIDatePicker) {
        recordData = RecordManager.shared.query().filter({$0.datetime.toString(format: "YYYY.M") == datepicker.date.toString(format: "YYYY.M")})
        selectedDateClosure()
    }
}
