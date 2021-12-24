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
    @IBOutlet weak var tagLabel: UILabel!
    
    var tagView: TagView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagView.frame = typeView.bounds
        
        tagLabel.backgroundColor = .clear
        tagLabel.layer.borderColor = UIColor.systemTeal.cgColor
        tagLabel.layer.borderWidth = 1
        tagLabel.layer.masksToBounds = true
        tagLabel.layer.cornerRadius = tagLabel.bounds.height * 0.5
        tagLabel.textColor = .systemTeal
        tagLabel.alpha = 0.8
        
    }
    
    func setTagView(text:String) {
        tagView = TagView(frame: typeView.bounds)
        tagView.titleLabel.text = text
        typeView.addSubview(tagView)
    }
}
