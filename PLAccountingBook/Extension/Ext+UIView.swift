//
//  Ext+UIView.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/17.
//

import UIKit

extension UIView {
    func loadXib(nibName: String,for aClass: AnyClass){
        let bundle = Bundle(for: aClass)
        let nib = UINib(nibName: nibName, bundle: bundle)
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
}
