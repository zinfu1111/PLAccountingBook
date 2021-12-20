//
//  EditRecordViewModel.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import UIKit

class EditRecordViewModel : NSObject {
    
    private(set) var record:Record!
    private(set) var accountType: [String]!
    
    var selectedDateClosure = {}
    var editAccountTypeClosure = {}
    var textFieldDidBeginEditingClosure = {}
    var textFieldDidEndEditing = {}
    
    init(record:Record) {
        self.record = record
        self.accountType = AccountTypeManager.query()
    }
    
}
//MARK: - DatePickerViewDelegate
extension EditRecordViewModel : DatePickerViewDelegate{
    
    func selected(_ datepicker: UIDatePicker) {
        self.record.datetime = datepicker.date
        selectedDateClosure()
    }
}
//MARK: - TextFieldPickerViewDelegate
extension EditRecordViewModel : TextFieldPickerViewDelegate {
    func selected(_ text: String) {
        
    }
    
    
}

//MARK: - UITextFieldDelegate
extension EditRecordViewModel : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditingClosure()
        switch textField.tag {
        case 1:
            editAccountTypeClosure()
//        case 2:
//
        case 3:
            textField.text = "\(record.cost)"
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
//        case 1:
//        case 2:
//
        case 3:
            record.cost = Double(textField.text ?? "0") ?? 0
            textField.text = Double(textField.text ?? "0")?.toMoneyFormatter()
        default:
            break
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Implement your Date Time Picker initial Code here
        switch textField.tag {
        case 1:
            editAccountTypeClosure()
            return false
        default:
            return true
        }
    }
}
