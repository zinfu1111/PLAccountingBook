//
//  RecordManager.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/13.
//

import UIKit
import CoreData

class RecordManager {
    
    static let shared = RecordManager()
    var appDelegate:AppDelegate!
    var context:NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    private func newId() -> Int {
        return query().count
    }
    
    func insert(with data:Record) {
        
        let record = RecordMO(context: context)
        record.id = Int64(newId())
        record.content = data.content
        record.cost = data.cost
        record.tag = data.tag
        record.datetime = data.datetime
        appDelegate.saveContext()
        
    }
    
    func find(by id:Int) -> Record? {
        let fetchRequest: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        do {
            guard let data = try context.fetch(fetchRequest).first(where: {$0.id == id}) else {
                return nil
            }
            
            return Record(dataMO: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func query() -> [Record] {
        let fetchRequest: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        do {
            let data = try context.fetch(fetchRequest)
            
            var result = [Record]()
            data.forEach { item in
                result.append(Record(dataMO: item))
            }
            return result.sorted(by: { return $0.datetime > $1.datetime })
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func update(with data:Record) {
        let fetchRequest: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        do {
            if let record = try context.fetch(fetchRequest).first(where: { $0.id == data.id! }){
                record.datetime = data.datetime
                record.tag = data.tag
                record.cost = data.cost
                record.content = data.content
                appDelegate.saveContext()
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func delete(with data:Record) {
        let fetchRequest: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        do {
            if let record = try context.fetch(fetchRequest).first(where: { $0.id == data.id! }){
                context.delete(record)
                appDelegate.saveContext()
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
