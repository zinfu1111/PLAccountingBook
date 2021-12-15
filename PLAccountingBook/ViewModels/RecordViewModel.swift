//
//  RecordViewModel.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import UIKit

class RecordViewModel: NSObject {

    private(set) var recordData = [Record](){
        didSet{
            self.bindRecordViewModelToController()
        }
    }
    var bindRecordViewModelToController = {}
    
    override init() {
        super.init()
        self.recordData = RecordManager.shared.query()
    }
}
