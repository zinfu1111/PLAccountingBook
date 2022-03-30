//
//  SettingViewController.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/16.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var autoPush: UISwitch!
    var viewModel:SettingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func pushRecordAction(_ sender: Any) {
        viewModel.manager.requestJSONDataByURL(.member, nil, resType: APIResponse.List<Member>.self) {[weak self] responseData, error in
            guard let weakSelf = self else { return }
            guard let error = error else {
                print(userId)
                if let data = responseData,let memberId = data.records.first(where: {$0.id == userId})?.fields.id {
                    weakSelf.viewModel.uploadRecord(by: memberId)
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
}
