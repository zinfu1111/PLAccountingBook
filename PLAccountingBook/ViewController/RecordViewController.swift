//
//  RecordViewController.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var dateButtonView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let datePickerView = DatePickerView()
    
    private var viewModel: RecordViewModel!
    private var dataSource: RecordTableViewDataSource<RecordCell,Record>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        createDatePickerView()
        hidePopupWhenTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = RecordViewModel()
        viewModel.selectedDateClosure = {[weak self] in
            guard let self = self else { return }
            self.dateButton.isEnabled = true
            self.updateHeaderView()
            self.updateTableView()
            
        }
        updateHeaderView()
        updateTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
        dateButtonView.layer.cornerRadius = dateButtonView.bounds.height * 0.5
        
    }

    @IBAction func showDatePicker(_ sender: Any) {
        self.dateButton.isEnabled = false
        //layer
        datePickerView.layer.borderWidth = 2
        datePickerView.layer.borderColor = UIColor.systemOrange.cgColor
        datePickerView.layer.cornerRadius = datePickerView.bounds.width * 0.1
        datePickerView.layer.masksToBounds = true
        datePickerView.show()
        
        //delegate
        datePickerView.delegate = viewModel
    }
    
}

extension RecordViewController {
    
    private func createDatePickerView() {
        
        //hide
        datePickerView.hide()
        
        //addView
        view.addSubview(datePickerView)
        
        //constraint
        datePickerView.tintColor = .systemTeal
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        datePickerView.topAnchor.constraint(equalTo: dateButtonView.bottomAnchor, constant: 0).isActive = true
        datePickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        view.rightAnchor.constraint(equalTo: datePickerView.rightAnchor, constant: 50).isActive = true
        
        
    }
    
    private func updateHeaderView() {
        self.dateLabel.text = datePickerView.datePicker.date.toString(format: "YYYY.M")
        self.totalCost.text = "本月 \(Int(viewModel.recordData.map({$0.cost}).reduce(.zero, +)).toMoneyFormatter()) 元"
    }
    
    private func updateTableView() {
        self.viewModel.updateRecord(date: datePickerView.datePicker.date)
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
                self.updateTableView()
            }
        }
        
    }
    
    private func hidePopupWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePopupView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closePopupView(){
        view.subviews.forEach { view in
            if let view = view as? PopupView {
                view.hide()
            }
        }
        dateButton.isEnabled = true
    }
}
