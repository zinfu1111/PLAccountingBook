//
//  EditRecordViewModel.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import UIKit

class EditRecordViewModel : NSObject {
    
    private(set) var record:Record!
    private(set) var tags: [String]!
    
    var selectedDateClosure = {}
    var editTagClosure = {}
    var endEditTagClosure = {}
    var textFieldDidEndEditing = {}
    var showTextFieldPickerView = false
    
    init(record:Record) {
        self.record = record
        self.tags = TagManager.query()
    }
    
    func setTag(text: String) {
        record.tag = text
        if TagManager.query().filter({$0 == text}).count == 0 {
            TagManager.addNewTypes(with: [text])
        }
    }
    
    func save(by data:Record) {
        
        if self.record.id == 0 {
            RecordManager.shared.insert(with: self.record)
        }else{
            RecordManager.shared.update(with: data)
        }
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
        endEditTagClosure()
    }
}

//MARK: - UITextFieldDelegate
extension EditRecordViewModel : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 3:
            textField.text = "\(record.cost)"
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 2:
            record.content = textField.text!
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
            editTagClosure()
            return false
        case 2,3:
            return !showTextFieldPickerView

        default:
            return true
        }
    }
}
