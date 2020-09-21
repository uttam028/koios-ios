//
//  OpenStudyBannerViewCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/7/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class OpenStudyBannerViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var studyImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.layoutIfNeeded()
    }
    
}
