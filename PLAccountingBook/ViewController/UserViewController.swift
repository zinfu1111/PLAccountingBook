//
//  UserViewController.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/16.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var settingView: UIView!
    
    var loginVC:LoginViewController!
    var settingVC:SettingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let id = UserDefaults.standard.string(forKey: "UserId") {
            loginView.isHidden = true
            userId = id
        }else {
            settingView.isHidden = true
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginVC = segue.destination as? LoginViewController,
                    segue.identifier == "LoginSegue" {
            self.loginVC = loginVC
            self.loginVC.viewModel = LoginViewModel()
            self.loginVC.viewModel.registerSuccese = {[weak self] data in
                guard let weakSelf = self else { return }
                weakSelf.loginView.isHidden = true
                weakSelf.settingView.isHidden = false
            }
            self.loginVC.viewModel.loginSuccese = self.loginVC.viewModel.registerSuccese
            
        } else if let settingVC = segue.destination as? SettingViewController,
                 segue.identifier == "SettingSegue" {
            self.settingVC = settingVC
        }
    }
}
