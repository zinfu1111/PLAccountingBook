//
//  APIResponse.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/17.
//

import Foundation

struct APIResponse {
    
    struct List<T:Codable>:Codable {
        
        let records: [Record]
        struct Record: Codable {
            let id: String
            let fields: T
        }
        
    }
}
