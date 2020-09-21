//
//  AppCenterIconsCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/4/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class AppCenterIconCell: UITableViewCell {
    var taskIconButton: AppCenterIconButton!
    var contextIconButton: AppCenterIconButton!
    var delegate:AppCenterIconCellDelegate?
    var taskIconLabel:AppCenterIconLabel!
    var contextIconLabel:AppCenterIconLabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        
        let taskImage = UIImage(named: "task") as UIImage?
        taskIconButton = AppCenterIconButton()
        taskIconButton.setBackgroundImage(taskImage, for: .normal)
        taskIconButton.addTarget(self, action: #selector(tapTaksIcon), for: .touchUpInside)
        
        taskIconLabel = AppCenterIconLabel()
        taskIconLabel.text = "Pending Task (0)"
        
        taskIconLabel.textAlignment = .center
        
        let verticalStackViewFirst = UIStackView(arrangedSubviews: [taskIconButton, taskIconLabel])
        verticalStackViewFirst.axis = .vertical
        verticalStackViewFirst.distribution = .fillProportionally
        verticalStackViewFirst.alignment = .fill
        verticalStackViewFirst.translatesAutoresizingMaskIntoConstraints = false
        
        
        let contextImage = UIImage(named: "context") as UIImage?
        contextIconButton = AppCenterIconButton()
        contextIconButton.setBackgroundImage(contextImage, for: .normal)
        contextIconButton.addTarget(self, action: #selector(tapContextIcon), for: .touchUpInside)
        contextIconLabel = AppCenterIconLabel()
        contextIconLabel.text = "Label Your Context"
        
        contextIconLabel.textAlignment = .center
        
        var verticalStackViewSecond = UIStackView(arrangedSubviews: [contextIconButton, contextIconLabel])
        verticalStackViewSecond.axis = .vertical
        verticalStackViewSecond.distribution = .fillProportionally
        verticalStackViewSecond.alignment = .fill
        //verticalStackViewSecond.spacing = 2
        verticalStackViewSecond.translatesAutoresizingMaskIntoConstraints = false
        
        
        if screenHeight < 600{
            taskIconLabel.font = UIFont(name: "Helvetica Neue", size: 10)
            contextIconLabel.font = UIFont(name: "Helvetica Neue", size: 10)
        } else if screenHeight < 700{
            taskIconLabel.font = UIFont(name: "Helvetica Neue", size: 12)
            contextIconLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        } else{
            taskIconLabel.font = UIFont(name: "Helvetica Neue", size: 14)
            contextIconLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        }

        
        var horizontalStackView = UIStackView(arrangedSubviews: [verticalStackViewFirst, verticalStackViewSecond])
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 10
        
        
        
        self.addSubview(horizontalStackView)
        
        let viewsDictionary = ["stackView":horizontalStackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[stackView]-20-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-30-[stackView]-30-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutConstraint.FormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.addConstraints(stackView_V)
        self.addConstraints(stackView_H)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        print("awake from nib")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func tapTaksIcon(){
        delegate?.taskIconTapped(self)
    }
    
    @objc func tapContextIcon(){
        delegate?.contextIconTapped(self)
    }
}

class AppCenterIconButton: UIButton {
    
    var height = 85
    /*
     required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     }*/
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: 80)
    }
}

class AppCenterIconLabel: UILabel {
    
    var height  = 15
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: 20)
    }
}

protocol AppCenterIconCellDelegate: class {
    func taskIconTapped(_ sender:AppCenterIconCell)
    func contextIconTapped(_ sender:AppCenterIconCell)
}
