//
//  TagDetailViewController.swift
//  PLAccountingBook
//
//  Created by User on 2022/1/17.
//

import UIKit

class TagDetailViewController: UIViewController {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var totalLabel:UILabel!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var filterTextField:UITextField!{
        didSet{
            filterTextField.attributedPlaceholder = NSAttributedString(string: "篩選", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            filterTextField.borderStyle = .roundedRect
            filterTextField.layer.borderWidth = 3
            filterTextField.layer.borderColor = UIColor.systemTeal.cgColor
            filterTextField.tag = 1
        }
    }

    private var dataSource: TagDetailTableDataSource<TagDetailCell,Record>!
    private let viewModel:TagDetailViewModel!
    
    init?(coder: NSCoder, tag:String, date:Date){
        self.viewModel = TagDetailViewModel(tag: tag, date: date)
        super.init(coder: coder)
    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagLabel.text = viewModel.tag
        totalLabel.text = "總金額 \(viewModel.record.map({ $0.cost }).reduce(0){ $0 + $1 }.toMoneyFormatter())"
        self.dataSource = TagDetailTableDataSource(cellIdentifier: "\(TagDetailCell.self)", items: viewModel.record, configCell: { cell,item in
            cell.dateLabel.text = item.datetime.toString(format: "M/d")
            cell.titleLabel.text = item.content
            cell.costLabel.text = item.cost.toMoneyFormatter()
        })
        DispatchQueue.main.async {
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }

}
