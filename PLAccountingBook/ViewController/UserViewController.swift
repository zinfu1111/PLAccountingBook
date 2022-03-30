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
        fetchUI()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginVC = segue.destination as? LoginViewController,
                    segue.identifier == "LoginSegue" {
            self.loginVC = loginVC
            self.loginVC.viewModel = LoginViewModel()
            self.loginVC.viewModel.registerSuccese = {[weak self] data in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    UserDefaults.standard.set(data.id, forKey: "UserId")
                    weakSelf.loginView.isHidden = true
                    weakSelf.settingView.isHidden = false
                }
            }
            self.loginVC.viewModel.loginSuccese = self.loginVC.viewModel.registerSuccese
            
        } else if let settingVC = segue.destination as? SettingViewController,
                 segue.identifier == "SettingSegue" {
            self.settingVC = settingVC
            self.settingVC.viewModel = SettingViewModel()
            self.settingVC.viewModel.logoutCompletion = {[weak self] in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    weakSelf.fetchUI()
                }
            }
        }
    }
    
    func fetchUI() {
        if let id = UserDefaults.standard.string(forKey: "UserId") {
            loginView.isHidden = true
            settingView.isHidden = false
            userId = id
        }else {
            settingView.isHidden = true
            loginView.isHidden = false
        }
        
    }
}
