//
//  AnalyticsViewController.swift
//  PLAccountingBook
//
//  Created by Paul on 2021/12/22.
//

import UIKit
import Charts
import DropDown

class AnalyticsViewController: UIViewController {

    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var panelHeader: UIView!
    
    private var panelHeaderView:PanelHeaderView!
    private var viewModel: AnalyticsViewModel!
    private var recordDataSource: RecordTableViewDataSource<RecordCell,Record>!
    private var tagCostDataSource: AnalyticsTableViewDataSource<TagCostCell,String>!
    private var yearDropDown:DropDown!
    private var monthDropDown:DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        yearDropDown = DropDown()
        monthDropDown = DropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        tabBarController?.tabBar.isHidden = false
        viewModel = AnalyticsViewModel()
        updateHeaderView()
        updateTableView()
        viewModel.updateTableViewWithPanel = {[weak self] in
            guard let self = self else { return }
            self.updateTableView()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePanel()
        updatePieChart()
    }
    @IBAction func showYear(_ sender: Any) {
        
        yearDropDown.anchorView = yearLabel
        yearDropDown.bottomOffset = CGPoint(x: 0, y: yearLabel.bounds.height)
        yearDropDown.dataSource = ["2021年","2022年","2023年","2024年","2025年"]
        
        yearDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            yearLabel.text = item
            viewModel.updateDate(year: item, month: monthLabel.text!)
            updateHeaderView()
            updateTableView()
            yearDropDown.hide()
        }
        yearDropDown.show()
    }
    @IBAction func showMonth(_ sender: Any) {
        
        monthDropDown.anchorView = monthLabel
        monthDropDown.bottomOffset = CGPoint(x: 0, y: monthLabel.bounds.height)
        monthDropDown.dataSource = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
        
        monthDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            monthLabel.text = item
            viewModel.updateDate(year: yearLabel.text!, month: item)
            updateHeaderView()
            updateTableView()
            monthDropDown.hide()
        }
        monthDropDown.show()
    }
    
    @IBSegueAction func goDetail(_ coder: NSCoder, sender: Any?) -> TagDetailViewController? {
        
        
        guard let indexPath = self.tableView.indexPathForSelectedRow
              else { return nil}
        return TagDetailViewController(coder: coder, tag: viewModel.tagData[indexPath.row], date: viewModel.currentMonth)
    }
    
}

extension AnalyticsViewController {
    
    private func updatePanel(){
        panelHeader.subviews.forEach({$0.removeFromSuperview()})
        panelHeaderView = PanelHeaderView(frame: panelHeader.bounds, data: viewModel.showType.allTitle)
        panelHeaderView.delegate = viewModel
        panelHeader.addSubview(panelHeaderView)
        
    }
    
    private func updateHeaderView() {
        print(#function)
        yearLabel.text = "\(viewModel.currentMonth.toString(format: "yyyy"))年"
        monthLabel.text = "\(viewModel.currentMonth.toString(format: "M"))月"
        
        totalCostLabel.text = "支出：\(viewModel.recordData.filter({$0.datetime.toString(format: "yyyy/M") == viewModel.currentMonth.toString(format: "yyyy/M")}).map({ $0.cost }).reduce(0){ $0 + $1 })元"
        
    }
    
    private func updatePieChart(){
        chartView.subviews.forEach({$0.removeFromSuperview()})
        let chart = PieChartView()
        chart.frame.size = CGSize(width: 175, height: 175)
        chart.center = chartView.center
        
        var entries = [PieChartDataEntry]()
        viewModel.tagData.forEach { tag in
            let tagTotal = viewModel.recordData.filter({$0.tag == tag}).filter({$0.datetime.toString(format: "yyyy/M") == viewModel.currentMonth.toString(format: "yyyy/M")}).map({ $0.cost }).reduce(0){ $0 + $1 }
            if tagTotal > 0 {
                
                let entry = PieChartDataEntry()
                entry.y = tagTotal
                entry.label = tag
                entries.append( entry)
            }
        }
        
        // 3. chart setup
        let set = PieChartDataSet( entries: entries, label: "")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []

        for _ in 0..<viewModel.tagData.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        set.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = false
        chart.drawEntryLabelsEnabled = false

        chart.holeRadiusPercent = 0
        chart.transparentCircleColor = UIColor.clear
        self.chartView.addSubview(chart)
    }
    
    private func setupDataSource(){
        
        //recordDataSource
        self.recordDataSource = RecordTableViewDataSource(cellIdentifier: "\(RecordCell.self)", items: self.viewModel.recordData, configCell: { cell, model in
            cell.tagLabel.text = model.tag
            cell.setTagView(text: String(model.tag.first!))
            cell.dateLabel.text = "\(model.datetime.toString(format: "MM/dd HH:mm"))"
            cell.contentTextView.text = model.content
            cell.costLabel.text = "\(Int(model.cost).toMoneyFormatter())元"
        })
        self.recordDataSource.editClosure = { item in
            let editRecordVC = self.storyboard?.instantiateViewController(withIdentifier: "\(EditRecordViewController.self)") as! EditRecordViewController
            editRecordVC.viewModel = EditRecordViewModel(record: item)
            self.navigationController?.pushViewController(editRecordVC, animated: true)
        }
        self.recordDataSource.deleteClosure = { item in
            RecordManager.shared.delete(with: item)
            
            DispatchQueue.main.async {
                self.viewModel.updateProperty()
                self.updateTableView()
            }
        }
        
        //tagCostDataSource
        self.tagCostDataSource = AnalyticsTableViewDataSource(cellIdentifier: "\(TagCostCell.self)", items: viewModel.tagData, configCell: { cell,tag in

            let totalCost = self.viewModel.recordData.map({ $0.cost }).reduce(0){ $0 + $1 }
            let tagCost = self.viewModel.recordData.filter({$0.tag == tag}).map({ $0.cost }).reduce(0){ $0 + $1 }
            cell.tagLabel.text = tag
            cell.setTagView(text: String(tag.first!))
            cell.progressView.progress = totalCost != 0 ? Float(tagCost/totalCost) : 0
            cell.percentLabel.text = totalCost != 0 ? "\(String(format: "%.2f", ((tagCost/totalCost) * 100)))%" : "0%"
            cell.costLabel.text = "\(tagCost.toMoneyFormatter())"
        })
        self.tagCostDataSource.selecedCell = {[weak self] item in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "goTagDetail", sender: nil)
        }
    }
    
    private func updateTableView(){
        print(#function)
        setupDataSource()
        
        DispatchQueue.main.async {

            switch self.viewModel.showType {
            case .main:
                self.tableView.rowHeight = 80
                self.tableView.dataSource = self.tagCostDataSource
                self.tableView.delegate = self.tagCostDataSource
            case .detail:
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.dataSource = self.recordDataSource
                self.tableView.delegate = self.recordDataSource
            case .none:
                break
            }
            
            
            
            self.tableView.reloadData()
        }
    }

}
