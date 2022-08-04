//
//  InComeViewController.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2022/8/4.
//

import UIKit

class InComeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    
    private var viewModel: InComeViewModel!
    private var dataSource: RecordTableViewDataSource<RecordCell,Record>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        viewModel = InComeViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTableDataSource()
        viewModel.updateData()
        updateTableView()
        updateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func goEditRecord(_ sender: Any) {
        let editRecordVC = self.storyboard?.instantiateViewController(withIdentifier: "\(EditRecordViewController.self)") as! EditRecordViewController
        editRecordVC.viewModel = EditRecordViewModel(record: Record(id: 0, memberId: 0, content: "", cost: 0, tag: "", datetime: Date(),savingTypeId: 0))
        navigationController?.pushViewController(editRecordVC, animated: true)
        
    }
    
    deinit {
        print("\(#function)")
    }
    
    
}

extension InComeViewController {
    
    
    private func updateLabel(){
        self.totalCostLabel.text =
        self.viewModel.recordData.filter({ $0.tag == "薪資"}).map({ $0.cost }).reduce(0, {$0 + $1}).toMoneyFormatter()
    }
    
    private func updateTableView() {
        self.setTableDataSource()
        DispatchQueue.main.async {
            self.tableView.delegate = self.dataSource
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    private func setTableDataSource(){
        self.dataSource = RecordTableViewDataSource(cellIdentifier: "\(RecordCell.self)", items: self.viewModel.recordData, configCell: { cell, model in
            cell.tagLabel.text = model.tag
            cell.setTagView(text: String(model.tag.first!))
            cell.dateLabel.text = "\(model.datetime.toString(format: "MM/dd HH:mm"))"
            cell.contentTextView.text = model.content
            cell.costLabel.text = "\(Int(model.cost).toMoneyFormatter())元"
        })
        self.dataSource.editClosure = { item in
            let editRecordVC = self.storyboard?.instantiateViewController(withIdentifier: "\(EditRecordViewController.self)") as! EditRecordViewController
            editRecordVC.viewModel = EditRecordViewModel(record: item)
            self.navigationController?.pushViewController(editRecordVC, animated: true)
        }
        self.dataSource.deleteClosure = { item in
            RecordManager.shared.delete(with: item)
            DispatchQueue.main.async {
                
                self.viewModel.updateData()
                self.updateTableView()
            }
        }
        
    }
}
