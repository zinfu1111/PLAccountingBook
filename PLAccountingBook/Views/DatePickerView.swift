//
//  DatePickerView.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/16.
//

import UIKit

protocol DatePickerViewDelegate {
    func selected(_ datepicker: UIDatePicker)
}

class DatePickerView: UIView,PopupView {

    @IBOutlet weak var datePicker:UIDatePicker!
    var delegate:DatePickerViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib(nibName: "\(DatePickerView.self)", for: type(of: self))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib(nibName: "\(DatePickerView.self)", for: type(of: self))
    }
    
    
    @IBAction func selectedDate(_ sender: UIDatePicker) {
        delegate?.selected(sender)
    }
}
