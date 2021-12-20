//
//  RecordViewController.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var createButtonView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var dateButtonView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let datePickerView = DatePickerView()
    
    private var viewModel: RecordViewModel!
    private var dataSource: RecordTableViewDataSource<RecordCell,Record>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePickerView()
        hidePopupWhenTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        dateButtonView.layer.cornerRadius = dateButtonView.bounds.height * 0.5
        createButtonView.layer.cornerRadius = createButtonView.bounds.height * 0.5
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
    
    @IBAction func goEditRecord(_ sender: Any) {
        let editRecordVC = self.storyboard?.instantiateViewController(withIdentifier: "\(EditRecordViewController.self)") as! EditRecordViewController
        editRecordVC.viewModel = EditRecordViewModel(record: Record(id: 0, content: "", cost: 0, tag: "", datetime: Date()))
        navigationController?.pushViewController(editRecordVC, animated: true)
        
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
        datePickerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        datePickerView.topAnchor.constraint(equalTo: dateButtonView.bottomAnchor, constant: 0).isActive = true
        datePickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        view.rightAnchor.constraint(equalTo: datePickerView.rightAnchor, constant: 50).isActive = true
        
        
    }
    
    private func updateHeaderView() {
        self.dateLabel.text = datePickerView.datePicker.date.toString(format: "YYYY.M")
        self.totalCost.text = "本月 \(Int(viewModel.recordData.map({$0.cost}).reduce(.zero, +)).toMoneyFormatter()) 元"
    }
    
    private func updateTableView() {
        
        self.dataSource = RecordTableViewDataSource(cellIdentifier: "\(RecordCell.self)", items: self.viewModel.recordData, configCell: { cell, model in
            cell.setTagView(text: model.tag)
            cell.dateLabel.text = "\(model.datetime.toString(format: "MM/dd HH:mm"))"
            cell.contentTextView.text = model.content
            cell.costLabel.text = "\(Int(model.cost).toMoneyFormatter())元"
        })
        DispatchQueue.main.async {
            
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
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
