//
//  TestCollectionViewCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/9/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    
    //var rectView:UIView!
    //var labelButton:UIButton!
    //var delegate:LabelViewCellDelegate!
    
    var subViewAdded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.layoutIfNeeded()
    }
    
    func addViews(){
        //rectView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        
        //let image = UIImage(named: "button") as UIImage?
        //labelButton = UIButton(type: UIButtonType.roundedRect) as UIButton
        //labelButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //labelButton.setBackgroundImage(image, for: .normal)
        //labelButton.addTarget(self, action: #selector(tapLabel), for: .touchUpInside)
        
        //rectView.addSubview(labelButton)
        //self.addSubview(rectView)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViewsToCell(imageName:String!, labelText:String){
        
        var tapIconImageView: TapIconImageView!
        var verticalStackView: UIStackView!
        
        let tapIconLabel = TapIconLabel()
        tapIconLabel.text = labelText
        tapIconLabel.textAlignment = .center
        tapIconLabel.numberOfLines = 1
        tapIconLabel.adjustsFontSizeToFitWidth = true
        tapIconLabel.minimumScaleFactor = 0.5
        tapIconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let name = imageName, !imageName.isEmpty{
            tapIconImageView = TapIconImageView()
            tapIconImageView.image = UIImage(named: name)
            tapIconImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            tapIconImageView.contentMode = .scaleAspectFit
            tapIconImageView.backgroundColor = UIColor.clear
            tapIconImageView.translatesAutoresizingMaskIntoConstraints = false
            
            verticalStackView = UIStackView(arrangedSubviews: [tapIconImageView, tapIconLabel])
        }else{
            verticalStackView = UIStackView(arrangedSubviews: [tapIconLabel])
        }

        
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        verticalStackView.alignment = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(verticalStackView)
        let viewsDictionary = ["stackView":verticalStackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-2-[stackView]-2-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[stackView]-3-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutConstraint.FormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.addConstraints(stackView_V)
        self.addConstraints(stackView_H)

        self.subViewAdded = true
        //layoutSubviews()
    }
    
    //@objc func tapLabel(){
        //delegate.labelTapped(self)
    //}
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                print("cell selected")
            }else{
                print("cell unselected...")
            }
        }
    }

}
class TapIconLabel: UILabel {
    
    var height  = 2
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: height)
    }
}

class TapIconImageView : UIImageView{
    var height = 4
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: height)
    }
}

protocol LabelViewCellDelegate: class {
    func labelTapped(_ sender:LabelCollectionViewCell)
}


