//
//  AccountType.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import Foundation

struct TagManager {
    
    static func createBaseData() {
        let url = Bundle.main.url(forResource: "Tag", withExtension: "plist")!
        
        
        guard let data = try? Data(contentsOf: url),
              let tags = try? PropertyListDecoder().decode([String].self, from: data) else {
                  return
                  
              }
        
        if tags.count > self.query().count {
            self.addNewTypes(with: tags)
        }
        
        
    }
    
    static func query() -> [String] {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let url = documentsDirectory.appendingPathComponent("Tag.plist")
        
        if let data = try? Data(contentsOf: url), let tags = try? PropertyListDecoder().decode([String].self, from: data) {
            return tags
        }
        return []
    }
    
    static func addNewTypes(with data: [String]) {
        
        var originData = self.query()
        originData += data.filter({!$0.isEmpty})
        
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
            let url = documentsDirectory.appendingPathComponent("Tag.plist")
            
            let writeData = try PropertyListEncoder().encode(originData)
            try writeData.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
