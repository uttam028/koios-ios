//
//  OpenStudyViewCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/5/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class OpenStudyViewCell: UICollectionViewCell {
    
    var organizationLabel:OpenStudyOrganizationLabel!
    var nameLabel:OpenStudyNameLabel!
    var staticJoinLabel:OpenStudyJoinLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()

    }
    
    
    func addViews(){
        
        organizationLabel = OpenStudyOrganizationLabel()
        organizationLabel.font = UIFont.systemFont(ofSize: 14)
        
        organizationLabel.textColor = UIColor(red: 0.051, green: 0.1216, blue: 0.2118, alpha: 1.0) /* #0d1f36 */
        organizationLabel.text = Utils.defaultOrganization
        organizationLabel.textAlignment = .center
        organizationLabel.translatesAutoresizingMaskIntoConstraints = false
        organizationLabel.numberOfLines = 0
        print("self \(self.frame.width), \(self.frame.height), \(organizationLabel.frame.width), \(organizationLabel.frame.height)")
        print("layer \(self.layer.frame.width), \(self.layer.frame.height), \(self.bounds.width), \(self.bounds.height)")
        //organizationLabel.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
    
        
        
        nameLabel = OpenStudyNameLabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = UIColor.black
        nameLabel.text = ""
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        
        staticJoinLabel = OpenStudyJoinLabel()
        staticJoinLabel.font = UIFont.systemFont(ofSize: 14)
        staticJoinLabel.textColor = UIColor(red: 0.051, green: 0.1216, blue: 0.2118, alpha: 1.0) /* #0d1f36 */
        staticJoinLabel.text = "Join"
        staticJoinLabel.textAlignment = .center
        staticJoinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let verticalStackView = UIStackView(arrangedSubviews: [organizationLabel, nameLabel, staticJoinLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 2
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(verticalStackView)
        
        
        
        let viewsDictionary = ["stackView":verticalStackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[stackView]-5-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-2-[stackView]-2-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutConstraint.FormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.addConstraints(stackView_V)
        self.addConstraints(stackView_H)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OpenStudyOrganizationLabel: UILabel {
    var height = 30
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: height)
    }
}

class OpenStudyNameLabel: UILabel {
    var height = 50
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: height)
    }
}

class OpenStudyJoinLabel: UILabel {
    var height = 20
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: height)
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        print("in layer \(self.bounds.width), \(self.bounds.height)")
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            print("program should come here....bottom, \(self.frame.height), \(thickness), \(self.frame.width)")
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

