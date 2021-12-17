//
//  Ext+Int.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import Foundation

extension Int {
    func toMoneyFormatter() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.numberStyle = .currencyISOCode
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
