//
//  NotificationViewCell.swift
//  tabletest01
//
//  Created by Afzal Hossain on 4/3/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
