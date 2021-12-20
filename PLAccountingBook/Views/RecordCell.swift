//
//  RecordCell.swift
//  PLAccountingBook
//
//  Created by 連振甫 on 2021/12/15.
//

import UIKit

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var contentTextView:UITextView!
    @IBOutlet weak var typeView:UIView!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var costLabel:UILabel!
    
    var tagView: TagView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        typeView.layer.cornerRadius = typeView.bounds.width * 0.5
        typeView.layer.masksToBounds = true
        tagView.frame = typeView.bounds
    }
    
    func setTagView(text:String) {
        tagView = TagView(frame: typeView.bounds)
        tagView.titleLabel.text = text
        typeView.addSubview(tagView)
    }
}
