//
//  HomeViewController.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/1/4.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var createButtonView: UIView!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    private var viewModel: HomeViewModel!
    private var dataSource: RecordTableViewDataSource<RecordCell,Record>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        viewModel = HomeViewModel()
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.calendarHeaderView.backgroundColor = .systemTeal
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .month
        
        self.createCalendarHeaderButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createButtonView.layer.cornerRadius = createButtonView.bounds.height * 0.5
        viewModel.updateData(date: self.calendar.selectedDate!)
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
        editRecordVC.viewModel = EditRecordViewModel(record: Record(id: 0, content: "", cost: 0, tag: "", datetime: self.calendar.selectedDate!))
        navigationController?.pushViewController(editRecordVC, animated: true)
        
    }
    
    deinit {
        print("\(#function)")
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate

extension HomeViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        print(self.tableView.contentOffset)
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
}

// MARK: - FSCalendarDelegate + FSCalendarDataSource

extension HomeViewController : FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.updateData(date: date)
        updateTableView()
        updateLabel()
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}
extension HomeViewController {
    
    private func createCalendarHeaderButton() {
        let leftButton = UIButton()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setTitle("<", for: .normal)
        leftButton.tintColor = .white
        self.calendar.calendarHeaderView.addSubview(leftButton)
        leftButton.topAnchor.constraint(equalTo: self.calendar.calendarHeaderView.topAnchor).isActive = true
        leftButton.leftAnchor.constraint(equalTo: self.calendar.calendarHeaderView.leftAnchor,constant: 20).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: self.calendar.calendarHeaderView.bottomAnchor).isActive = true
        
        
        let rightButton = UIButton()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setTitle(">", for: .normal)
        rightButton.tintColor = .white
        self.calendar.calendarHeaderView.addSubview(rightButton)
        rightButton.topAnchor.constraint(equalTo: self.calendar.calendarHeaderView.topAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: self.calendar.calendarHeaderView.rightAnchor,constant: -20).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: self.calendar.calendarHeaderView.bottomAnchor).isActive = true
    }
    
    
    
    private func updateLabel(){
        self.dateLabel.text = self.calendar.selectedDate!.toString(format: "YYYY年M月d日")
        self.totalCostLabel.text =
            self.viewModel.recordData.filter({$0.datetime.toString(format: "YYYY/MM/dd") == self.calendar.selectedDate!.toString(format: "YYYY/MM/dd")}).map({ $0.cost }).reduce(0, {$0 + $1}).toMoneyFormatter()
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
