//
//  PopupViewManager.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/16.
//

import UIKit

protocol PopupView : UIView{
    func hide()
}
extension PopupView {
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { _ in
            self.isHidden = false
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
        }

    }
}
