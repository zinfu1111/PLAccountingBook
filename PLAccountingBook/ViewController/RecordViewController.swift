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
        hidePopupWhenTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createDatePickerView()
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    func updateHeaderView() {
        self.dateLabel.text = datePickerView.datePicker.date.toString(format: "YYYY.M")
        self.totalCost.text = "本月 \(Int(viewModel.recordData.map({$0.cost}).reduce(.zero, +)).toMoneyFormatter()) 元"
    }
    
    func createDatePickerView() {
        
        //addView
        view.addSubview(datePickerView)
        
        //constraint
        datePickerView.tintColor = .systemTeal
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        datePickerView.topAnchor.constraint(equalTo: dateButtonView.bottomAnchor, constant: 0).isActive = true
        datePickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        view.rightAnchor.constraint(equalTo: datePickerView.rightAnchor, constant: 50).isActive = true
        
        
        //hide
        datePickerView.hide()
        
    }
    
    func updateTableView() {
        
        self.dataSource = RecordTableViewDataSource(cellIdentifier: "\(RecordCell.self)", items: self.viewModel.recordData, configCell: { cell, model in
            cell.contentTextView.text = model.content
            cell.setTagView(text: model.tag)
            cell.costLabel.text = "\(model.cost)元"
            cell.dateLabel.text = "\(model.datetime.toString(format: "MM/dd"))"
        })
        DispatchQueue.main.async {
            
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    func hidePopupWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePopupView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func closePopupView(){
        view.subviews.forEach { view in
            if let view = view as? PopupView {
                view.hide()
            }
        }
        dateButton.isEnabled = true
    }
}

