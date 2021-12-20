//
//  TagView.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import UIKit

class TagView: UIView {

    @IBOutlet weak var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib(nibName: "\(TagView.self)", for: type(of: self))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib(nibName: "\(TagView.self)", for: type(of: self))
    }
    
}
