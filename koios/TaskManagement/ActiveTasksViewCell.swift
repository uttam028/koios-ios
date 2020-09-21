//
//  ActiveSurveyTableViewCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 2/27/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class ActiveTasksViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let descLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descLabel.font = UIFont(name: "HelveticaNeue-Light", size:22)
        nameLabel.font = UIFont (name: "Baskerville", size: 20)
        
        contentView.addSubview(descLabel)
        contentView.addSubview(nameLabel)
        let viewsDict = [
            "surveyname" : nameLabel,
            "surveydesc" : descLabel,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[surveydesc]-[surveyname]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[surveyname]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[surveydesc]-|", options: [], metrics: nil, views: viewsDict))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


