//
//  EditRecordViewController.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import UIKit

class EditRecordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var accountTypeTextField:UITextField!{
        didSet{
            accountTypeTextField.text = viewModel.record.tag
            accountTypeTextField.attributedPlaceholder = NSAttributedString(string: "輸入類型", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
            accountTypeTextField.borderStyle = .roundedRect
            accountTypeTextField.layer.borderWidth = 3
            accountTypeTextField.layer.borderColor = UIColor.systemTeal.cgColor
            accountTypeTextField.delegate = viewModel
            accountTypeTextField.tag = 1
        }
    }
    @IBOutlet weak var contentTextField:UITextField!{
        didSet{
            contentTextField.text = viewModel.record.content
            contentTextField.attributedPlaceholder = NSAttributedString(string: "輸入內容", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
            contentTextField.borderStyle = .roundedRect
            contentTextField.layer.borderWidth = 3
            contentTextField.layer.borderColor = UIColor.systemTeal.cgColor
            contentTextField.delegate = viewModel
            contentTextField.tag = 2
        }
    }
    @IBOutlet weak var costTextField:UITextField!{
        didSet{
            costTextField.keyboardType = .decimalPad
            costTextField.text = "\(viewModel.record.cost.toMoneyFormatter())"
            costTextField.attributedPlaceholder = NSAttributedString(string: "輸入金額", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
            costTextField.borderStyle = .roundedRect
            costTextField.layer.borderWidth = 3
            costTextField.layer.borderColor = UIColor.systemTeal.cgColor
            costTextField.delegate = viewModel
            costTextField.tag = 3
        }
    }
    
    let datePickerView = DatePickerView()
    var viewModel: EditRecordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDatePickerView()
        hidePopupWhenTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.setNavigationBarHidden(false, animated: animated)
        viewModel.textFieldDidBeginEditingClosure = {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
        viewModel.selectedDateClosure = {[weak self] in
            guard let self = self else { return }
            self.dateButton.isEnabled = true
            self.dateLabel.text = "\(self.viewModel.record.datetime.toString(format: "YYYY/M/d HH:mm"))"
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.dateButton.layer.cornerRadius = self.dateButton.bounds.width * 0.5
        self.dateButton.layer.masksToBounds = true
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
    
    private func createDatePickerView() {
        
        //hide
        datePickerView.hide()
        datePickerView.datePicker.datePickerMode = .dateAndTime
        //addView
        view.addSubview(datePickerView)
        
        //constraint
        datePickerView.tintColor = .systemTeal
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        datePickerView.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 0).isActive = true
        datePickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        view.rightAnchor.constraint(equalTo: datePickerView.rightAnchor, constant: 50).isActive = true
        
        
    }
    private func hidePopupWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePopupView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closePopupView(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.subviews.forEach { view in
            if let view = view as? PopupView {
                view.hide()
            }
        }
        view.endEditing(true)
    }

}
