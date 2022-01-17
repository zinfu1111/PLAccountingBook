//
//  TagDetailCell.swift
//  PLAccountingBook
//
//  Created by User on 2022/1/17.
//

import UIKit

class TagDetailCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var costLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
