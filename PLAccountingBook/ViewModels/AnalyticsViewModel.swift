//
//  AnalyticsViewModel.swift
//  PLAccountingBook
//
//  Created by Paul on 2021/12/22.
//

import UIKit

enum AnalyticsShowType:Int,CaseIterable {
    case main = 0
    case detail = 1
    
    var title:String {
        switch self {
        case .main:
            return "百分比"
        case .detail:
            return "收支明細"
        }
    }
    
    var allTitle:[String]{
        var res = [String]()
        AnalyticsShowType.allCases.forEach { item in
            res.append(item.title)
        }
        return res
    }
}

class AnalyticsViewModel: NSObject,PanelHeaderViewDelegate {
    
    private(set) var currentMonth:Date!
    private(set) var recordData:[Record]!
    private(set) var tagData: [String]!
    private(set) var showType: AnalyticsShowType!
    
    var updateTableViewWithPanel = {}
    
    override init(){
        super.init()
        
        showType = .main
        currentMonth = Date()
        updateProperty()
        
    }
    
    func updateProperty() {
        self.recordData = RecordManager.shared.query().filter({$0.datetime.toString(format: "yyyy-mm-dd") == currentMonth.toString(format: "yyyy-mm-dd")})
        self.tagData = TagManager.query()
    }
    
    func updateDate(year:String,month:String) {
        let strDate = "\(year)\(month)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月"
        self.currentMonth = dateFormatter.date(from: strDate) ?? Date()
        updateProperty()
    }
    
    func selected(index: Int) {
        showType = AnalyticsShowType(rawValue: index)
        updateTableViewWithPanel()
    }
}
