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
    
    
    private var viewModel: AnalyticsViewModel!
    private var dataSource: AnalyticsTableViewDataSource<TagCostCell,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        viewModel = AnalyticsViewModel()
        updateHeaderView()
        updateTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePieChart()
    }
}

extension AnalyticsViewController {
    
    private func updateHeaderView() {
        yearLabel.text = "\(Date().toString(format: "yyyy"))年"
        monthLabel.text = "\(Date().toString(format: "M"))月"
        
        totalCostLabel.text = "支出：\(viewModel.recordData.filter({$0.datetime.toString(format: "yyyy.M") == Date().toString(format: "yyyy.M")}).map({ $0.cost }).reduce(0){ $0 + $1 })元"
        
    }
    
    private func updatePieChart(){
        chartView.subviews.forEach({$0.removeFromSuperview()})
        let chart = PieChartView()
        chart.frame.size = CGSize(width: 175, height: 175)
        chart.center = chartView.center
        
        var entries = [PieChartDataEntry]()
        viewModel.tagData.forEach { tag in
            let tagTotal = viewModel.recordData.filter({$0.tag == tag}).filter({$0.datetime.toString(format: "yyyy.M") == Date().toString(format: "yyyy.M")}).map({ $0.cost }).reduce(0){ $0 + $1 }
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
    
    private func updateTableView(){
        self.dataSource = AnalyticsTableViewDataSource(cellIdentifier: "\(TagCostCell.self)", items: viewModel.tagData, configCell: { cell,tag in

            let totalCost = self.viewModel.recordData.filter({$0.datetime.toString(format: "yyyy.M") == Date().toString(format: "yyyy.M")}).map({ $0.cost }).reduce(0){ $0 + $1 }
            let tagCost = self.viewModel.recordData.filter({$0.tag == tag}).filter({$0.datetime.toString(format: "yyyy.M") == Date().toString(format: "yyyy.M")}).map({ $0.cost }).reduce(0){ $0 + $1 }
            cell.tagLabel.text = tag
            cell.setTagView(text: String(tag.first!))
            cell.progressView.progress = totalCost != 0 ? Float(tagCost/totalCost) : 0
            cell.percentLabel.text = totalCost != 0 ? "\(String(format: "%.2f", ((tagCost/totalCost) * 100)))%" : "0%"
            cell.costLabel.text = "\(tagCost.toMoneyFormatter())"
        })
        DispatchQueue.main.async {

            self.tableView.dataSource = self.dataSource
            self.tableView.delegate = self.dataSource
            self.tableView.reloadData()
        }
    }

}
