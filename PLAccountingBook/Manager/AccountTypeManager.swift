//
//  AccountType.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import Foundation

struct AccountTypeManager {
    
    static func query() -> [String] {
        let url = Bundle.main.url(forResource: "AccountType", withExtension: "plist")!
                
        if let data = try? Data(contentsOf: url), let accountTypes = try? PropertyListDecoder().decode([String].self, from: data) {
            return accountTypes
        }
        return []
    }
    
    static func addNewTypes(with data: [String]) {
        
        var originData = self.query()
        originData += data
        
        do {
            let url = Bundle.main.url(forResource: "AccountType", withExtension: "plist")!
            let writeData = try PropertyListEncoder().encode(originData)
            try writeData.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
