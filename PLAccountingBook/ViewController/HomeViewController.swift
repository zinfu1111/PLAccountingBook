//
//  HomeViewController.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/1/4.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButtonView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    private var viewModel: HomeViewModel!
    private var dataSource: RecordTableViewDataSource<RecordCell,Record>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        viewModel = HomeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createButtonView.layer.cornerRadius = createButtonView.bounds.height * 0.5
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
    
    @IBAction func selectedDate(_ sender: UIDatePicker) {
        viewModel.updateData(date: sender.date)
        updateTableView()
        updateLabel()
    }
    
    
    @IBAction func goEditRecord(_ sender: Any) {
        let editRecordVC = self.storyboard?.instantiateViewController(withIdentifier: "\(EditRecordViewController.self)") as! EditRecordViewController
        editRecordVC.viewModel = EditRecordViewModel(record: Record(id: 0, content: "", cost: 0, tag: "", datetime: Date()))
        navigationController?.pushViewController(editRecordVC, animated: true)
        
    }
}

extension HomeViewController {
    
    private func updateLabel(){
        self.dateLabel.text = datePicker.date.toString(format: "YYYY年M月d日")
        self.totalCostLabel.text =
            self.viewModel.recordData.filter({$0.datetime.toString(format: "YYYY/MM/dd") == datePicker.date.toString(format: "YYYY/MM/dd")}).map({ $0.cost }).reduce(0, {$0 + $1}).toMoneyFormatter()
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
