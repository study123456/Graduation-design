//
//  KWResultViewCell.swift
//  小学100以内口算练习
//
//  Created by Mr.Hu on 2021/6/13.
//

import UIKit

class KWResultViewCell: UITableViewCell {

    @IBOutlet weak var rTitleLabel: UILabel!
    
    @IBOutlet weak var wrLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
