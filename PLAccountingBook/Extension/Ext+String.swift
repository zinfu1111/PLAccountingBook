//
//  Ext+String.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/30.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date ?? Date()

    }
}
