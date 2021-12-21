//
//  AccountTypePickerView.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/20.
//

import UIKit

protocol TextFieldPickerViewDelegate {
    func selected(_ text: String)
}

class TextFieldPickerView: UIView {

    @IBOutlet weak var textField:UITextField!{
        didSet{
            textField.attributedPlaceholder = NSAttributedString(string: "選擇類別或輸入類別", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
            textField.borderStyle = .roundedRect
            textField.layer.borderWidth = 3
            textField.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    @IBOutlet weak var pickerView:UIPickerView!
    var data = [String](){
        didSet{
            self.pickerView.dataSource = self
            self.pickerView.delegate = self 
            self.pickerView.reloadAllComponents()
        }
    }
    var delegate:TextFieldPickerViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib(nibName: "\(TextFieldPickerView.self)", for: type(of: self))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib(nibName: "\(TextFieldPickerView.self)", for: type(of: self))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = textField.frame.height * 0.1
    }
    
    @IBAction func ckeckAction(_ sender: Any) {
        delegate?.selected(textField.text!)
    }
}

//MARK: - UIPickerViewDelegate&UIPickerViewDataSource
extension TextFieldPickerView : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = data[row]
    }
}

