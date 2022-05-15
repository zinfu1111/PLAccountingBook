//
//  SettingViewController.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/16.
//

import UIKit
import NVActivityIndicatorView

class SettingViewController: UIViewController {

    @IBOutlet weak var autoPush: UISwitch!
    var spinnerView:UIView!
    var viewModel:SettingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //TODO: setup navigationController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        
        //TODO: setup spinner view
        spinnerView = UIView()
        spinnerView.frame.size = CGSize(width: 100, height: 100)
        spinnerView.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        spinnerView.layer.cornerRadius = 10
        spinnerView.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.view.addSubview(spinnerView)
        
        
        let label = UILabel()
        label.frame.size = CGSize(width: spinnerView.bounds.width, height: 30)
        label.center = CGPoint(x: spinnerView.frame.width/2, y: spinnerView.frame.height/2)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Loading..."
        label.font = label.font.withSize(8)
        spinnerView.addSubview(label)
        
        let activityIndicatorView = NVActivityIndicatorView(frame: spinnerView.bounds, type: .circleStrokeSpin, color: .green, padding: 20)
        spinnerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        spinnerView.isHidden = true
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bringSubviewToFront(spinnerView)
    }
    
    
    @IBAction func pushRecordAction(_ sender: Any) {
        startSpinner()
        viewModel.manager.requestJSONDataByURL(.member, nil, resType: APIResponse.List<Member>.self) {[weak self] responseData, error in
            guard let weakSelf = self else { return }
            guard let error = error else {
                print(userId)
                if let data = responseData,let memberId = data.records.first(where: {$0.id == userId})?.fields.id {
                    weakSelf.viewModel.uploadRecord(by: memberId) {
                        weakSelf.stopSpinner()
                        let alert = UIAlertController(title: "成功", message: "上傳完成", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "確認", style: .cancel))
                        weakSelf.tabBarController?.present(alert, animated: true)
                        
                    }
                }
                
                
                return
                
            }
//            weakSelf.connectError?(error.localizedDescription)
        }
        
    }
    
    @IBAction func pullRecordAction(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        viewModel.logout()
    }
    
    
    func startSpinner() {
        DispatchQueue.main.async {
            self.spinnerView.isHidden = false
        }
    }
    
    func stopSpinner() {
        DispatchQueue.main.async {
            self.spinnerView.isHidden = true
        }
    }
}
