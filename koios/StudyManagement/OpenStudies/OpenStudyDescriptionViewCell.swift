//
//  OpenStudyDescriptionViewCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/7/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class OpenStudyDescriptionViewCell: UITableViewCell {

    var descriptionLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        descriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = ""
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(descriptionLabel)
        let viewsDictionary = ["view":descriptionLabel]
        
        let view_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[view]-10-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let view_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[view]-15-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutConstraint.FormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.addConstraints(view_V)
        self.addConstraints(view_H)
        

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
