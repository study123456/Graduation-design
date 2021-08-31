//
//  KWFillViewCell.swift
//  小学100以内口算练习
//
//  Created by Mr.Hu on 2021/6/11.
//

import UIKit

class KWFillViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var cellTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.keyboardType = .numberPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
