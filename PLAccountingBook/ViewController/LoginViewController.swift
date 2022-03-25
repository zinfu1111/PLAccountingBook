//
//  LoginViewController.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/16.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    var viewModel:LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func Login(_ sender: UIButton) {
        
        viewModel.login(phone: phoneTextField.text!, mail: mailTextField.text!)
        
    }
    
}
