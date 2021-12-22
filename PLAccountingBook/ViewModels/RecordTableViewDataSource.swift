//
//  RecordTableViewDataSource.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import UIKit

class RecordTableViewDataSource<CELL:UITableViewCell,T>: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    private var cellIdentifier:String!
    
    private var items:[T]!
    
    var configCell: (CELL,T) -> () = { _,_ in }
    var editClosure: (T) -> () = { _ in}
    var deleteClosure: (T) -> () = { _ in}
    
    init(cellIdentifier: String, items: [T], configCell: @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configCell = configCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.register(UINib(nibName: "\(CELL.self)", bundle: nil), forCellReuseIdentifier: "\(CELL.self)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        let item = items[indexPath.row]
        
        self.configCell(cell, item)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除"){[weak self]
            (action, sourceView, completionHandler) in
            guard let self = self else { return }
            self.deleteClosure(self.items[indexPath.row])
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let editeAction = UIContextualAction(style: .destructive, title: "編輯"){[weak self]
            (action, sourceView, completionHandler) in
            guard let self = self else { return }
            self.editClosure(self.items[indexPath.row])
            completionHandler(true)
        }
        
        editeAction.backgroundColor = .orange
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editeAction])
        
        return swipeConfiguration
    }
}
