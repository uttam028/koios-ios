//
//  HomeIconViewCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/15/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class HomeIconViewCell: UITableViewCell {

    var iconImageView:UIImageView!
    //var iconImageView:HomeIconImageView!
    //var iconLabel:HomeIconLabel!
    //var iconSubLabel:HomeIconSubLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            //HomeIconImageView()
        //iconImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        iconImageView.contentMode = .scaleAspectFit
        //iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.alignment = .fill
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(horizontalStackView)
        let viewsDictionary = ["stackView":horizontalStackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-25-[stackView]-0-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[stackView]-0-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutConstraint.FormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.addConstraints(stackView_V)
        self.addConstraints(stackView_H)

        
        /*
        iconLabel = HomeIconLabel()
        iconLabel.text = ""
        iconLabel.textAlignment = .center
        iconLabel.font = UIFont(name: "Raleway-Thin", size: 30)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        iconSubLabel = HomeIconSubLabel()
        iconSubLabel.text = "Pending (0)"
        iconSubLabel.numberOfLines = 0
        iconSubLabel.textAlignment = .center
        iconSubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalStackView = UIStackView(arrangedSubviews: [iconLabel, iconSubLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        verticalStackView.alignment = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false


        let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView, verticalStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.alignment = .fill
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(horizontalStackView)
        let viewsDictionary = ["stackView":horizontalStackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[stackView]-20-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-30-[stackView]-30-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.addConstraints(stackView_V)
        self.addConstraints(stackView_H)
         */

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.layoutIfNeeded()
    }

}


class HomeIconImageView: UIImageView {
    
    var width = 45
    /*
     required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     }*/
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: width, height: 0)
    }
}

class HomeIconLabel: UILabel {
    
    var width  = 55
    var height = 20
    override var intrinsicContentSize: CGSize{
        return CGSize(width: width, height: height)
    }
}

class HomeIconSubLabel: UILabel {
    var width  = 55
    var height = 5
    override var intrinsicContentSize: CGSize{
        return CGSize(width: width, height: height)
    }
}

/*
class HomeIconImageView: UIImageView {
    
    var height = 75
    /*
     required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     }*/
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: height)
    }
}

class HomeIconLabel: UILabel {
    
    var height  = 25
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: height)
    }
}
*/
