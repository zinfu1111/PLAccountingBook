//
//  TagCostCell.swift
//  PLAccountingBook
//
//  Created by Paul on 2021/12/23.
//

import UIKit

class TagCostCell: UITableViewCell {

    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    var tagView:TagView!
    
    func setTagView(text:String) {
        tagView = TagView(frame: typeView.bounds)
        tagView.titleLabel.text = text
        typeView.addSubview(tagView)
    }
}
