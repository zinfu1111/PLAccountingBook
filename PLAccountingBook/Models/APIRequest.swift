//
//  APIRequest.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/17.
//

import Foundation

struct APIRequest {
    
    struct Create<T:Codable>:Codable {
        
        let records: [Record]
        struct Record: Codable {
            let fields: T
        }
        
    }
    
    struct Update<T:Codable>:Codable {
        
        let records: [Record]
        struct Record: Codable {
            let id: String
            let fields: T
        }
        
    }
    
    struct Delete:Codable {
        let records: [Record]
        struct Record: Codable {
            let id: String
            let deleted: Bool
        }
    }
    
}
