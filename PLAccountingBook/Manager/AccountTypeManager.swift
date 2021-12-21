//
//  AccountType.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import Foundation

struct AccountTypeManager {
    
    static func createBaseData() {
        let url = Bundle.main.url(forResource: "AccountType", withExtension: "plist")!
        
        
        guard let data = try? Data(contentsOf: url),
              let accountTypes = try? PropertyListDecoder().decode([String].self, from: data) else {
                  return
                  
              }
        
        if accountTypes.count > self.query().count {
            self.addNewTypes(with: accountTypes)
        }
        
        
    }
    
    static func query() -> [String] {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let url = documentsDirectory.appendingPathComponent("AccountType.plist")
        
        if let data = try? Data(contentsOf: url), let accountTypes = try? PropertyListDecoder().decode([String].self, from: data) {
            return accountTypes
        }
        return []
    }
    
    static func addNewTypes(with data: [String]) {
        
        var originData = self.query()
        originData += data.filter({!$0.isEmpty})
        
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
            let url = documentsDirectory.appendingPathComponent("AccountType.plist")
            
            let writeData = try PropertyListEncoder().encode(originData)
            try writeData.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
