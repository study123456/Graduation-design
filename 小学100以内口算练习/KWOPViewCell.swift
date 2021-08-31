//
//  KWOPViewCell.swift
//  小学100以内口算练习
//
//  Created by Mr.Hu on 2021/6/10.
//

import UIKit

class KWOPViewCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellImgV: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 2;
        bgView.layer.borderColor = kLineColor.cgColor
        bgView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
