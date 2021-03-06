//
//  TagDetailTableDataSource.swift
//  PLAccountingBook
//
//  Created by User on 2022/1/17.
//

import UIKit

class TagDetailTableDataSource<CELL:UITableViewCell,T>: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    private var cellIdentifier:String!
    
    private var items:[T]!
    
    var configCell: (CELL,T) -> () = { _,_ in }
    
    init(cellIdentifier: String, items: [T], configCell: @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configCell = configCell
        print(#function)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.register(UINib(nibName: "\(CELL.self)", bundle: nil), forCellReuseIdentifier: "\(CELL.self)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        let item = items[indexPath.row]
        
        self.configCell(cell, item)
        print(#function)
        return cell
        
    }
    
}
