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
        loadXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "\(DatePickerView.self)", bundle: bundle)
        ///透過nib來取得xibView
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(xibView)
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @IBAction func selectedDate(_ sender: UIDatePicker) {
        delegate?.selected(sender)
    }
}
