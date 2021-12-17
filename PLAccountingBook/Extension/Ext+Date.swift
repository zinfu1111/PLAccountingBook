//
//  Ext+Date.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import Foundation

extension Date {
    func toString(format:String) -> String {
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
