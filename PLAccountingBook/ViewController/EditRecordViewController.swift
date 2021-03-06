//
//  EditRecordViewController.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import UIKit
import SnapKit

class EditRecordViewController: UIViewController {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagTextField:UITextField!{
        didSet{
            tagTextField.text = viewModel.record.tag
            tagTextField.attributedPlaceholder = NSAttributedString(string: "輸入類型", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
            tagTextField.borderStyle = .roundedRect
            tagTextField.layer.borderWidth = 3
            tagTextField.layer.borderColor = UIColor.systemTeal.cgColor
            tagTextField.delegate = viewModel
            tagTextField.tag = 1
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
    let textFieldPickerView = TextFieldPickerView()
    let datePickerView = DatePickerView()
    var viewModel: EditRecordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        createTextFieldPickerView()
        createDatePickerView()
        setupViewModelClosure()
        hidePopupWhenTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.dateButton.layer.cornerRadius = self.dateButton.bounds.width * 0.5
        self.dateButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .white
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
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
    
    @IBAction func save(_ sender: Any){
        
        let record = Record(id: viewModel.record.id, content: contentTextField.text!, cost: viewModel.record.cost, tag: tagTextField.text!, datetime: datePickerView.datePicker.date)
        
        viewModel.save(by: record)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
}

extension EditRecordViewController {
    
    private func setupViewModelClosure(){
        
        viewModel.editTagClosure = {[weak self] in
            guard let self = self else { return }
            let data = TagManager.query()
            self.textFieldPickerView.data = data
            self.textFieldPickerViewShowOrHide(true)
            
            //delegate
            self.textFieldPickerView.delegate = self.viewModel
            
        }
        viewModel.endEditTagClosure = {[weak self] in
            guard let self = self else { return }
            self.textFieldPickerViewShowOrHide(false)
        }
        viewModel.selectedDateClosure = {[weak self] in
            guard let self = self else { return }
            self.dateButton.isEnabled = true
            self.dateLabel.text = "\(self.viewModel.record.datetime.toString(format: "YYYY/M/d HH:mm"))"
            
        }
    }
    
    private func createTextFieldPickerView() {
        
        //hide
        textFieldPickerView.isHidden = true
        //addView
        view.addSubview(textFieldPickerView)
        
        //constraint
        textFieldPickerView.tintColor = .systemTeal
        textFieldPickerView.translatesAutoresizingMaskIntoConstraints = false
        textFieldPickerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.3).isActive = true
        textFieldPickerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height*0.3).isActive = true
        textFieldPickerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height*0.3).isActive = false
        textFieldPickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: textFieldPickerView.rightAnchor, constant: 0).isActive = true

        textFieldPickerView.textField.text = viewModel.record.tag
    }
    
    private func createDatePickerView() {
        
        //hide
        datePickerView.hide()
        datePickerView.datePicker.datePickerMode = .dateAndTime
        datePickerView.datePicker.date = viewModel.record.datetime
        //addView
        view.addSubview(datePickerView)
        
        //constraint
        datePickerView.tintColor = .systemTeal
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        datePickerView.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 0).isActive = true
        datePickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        view.rightAnchor.constraint(equalTo: datePickerView.rightAnchor, constant: 50).isActive = true
        
        dateLabel.text = datePickerView.datePicker.date.toString(format: "yyyy/M/d HH:mm")
        
    }
    
    private func textFieldPickerViewShowOrHide(_ isShow:Bool){
        if isShow{
            
            self.viewModel.showTextFieldPickerView = true
            self.textFieldPickerView.isHidden = false
            UIView.animate(withDuration: 1) {
                self.textFieldPickerView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: UIScreen.main.bounds.height*0.3).isActive = false
                self.textFieldPickerView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.main.bounds.height*0.3).isActive = true
                self.view.layoutIfNeeded()
            }

            
        }else{
            
            UIView.animate(withDuration: 1) {
                self.textFieldPickerView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: UIScreen.main.bounds.height*0.3).isActive = true
                self.textFieldPickerView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.main.bounds.height*0.3).isActive = false
                self.view.layoutIfNeeded()
            } completion: { finished in
                if finished {
                    
                    self.textFieldPickerView.isHidden = true
                    self.viewModel.showTextFieldPickerView = false
                    
                    self.tagTextField.text = self.textFieldPickerView.textField.text
                    self.viewModel.setTag(text: self.textFieldPickerView.textField.text!)
                }
            }

        }
    }
    
    private func hidePopupWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePopupView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closePopupView(){
        view.subviews.forEach { view in
            if let view = view as? PopupView {
                view.hide()
            }
        }
        view.endEditing(true)
        dateButton.isEnabled = true
        textFieldPickerViewShowOrHide(false)
    }

}
