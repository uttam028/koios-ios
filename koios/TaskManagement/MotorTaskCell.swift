//
//  MotorTaskCell.swift
//  cimonv2
//
//  Created by Afzal Hossain on 3/3/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Eureka


struct MotorTask:Equatable {
    var type: String
    //var pictureUrl:URL?
    var imagePath:String
}
func ==(lhs: MotorTask, rhs: MotorTask) -> Bool {
    return lhs.type == rhs.type
}


final class MotorTaskCell: Cell<MotorTask>, CellType {
    
    @IBOutlet weak var taskImageView: UIImageView!
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        // we do not want our cell to be selected in this case. If you use such a cell in a list then you might want to change this.
        selectionStyle = .none
        
        // configure our profile picture imageView
        taskImageView.contentMode = .scaleAspectFill
        taskImageView.clipsToBounds = true
        
        
        // specify the desired height for our cell
        height = { return 94 }
        
        // set a light background color for our cell
        backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
    }
    
    override func update() {
        super.update()
        
        // we do not want to show the default UITableViewCell's textLabel
        //textLabel?.text = nil
        
        // get the value from our row
        guard let task = row.value else { return }
        
        // set the image to the userImageView. You might want to do this with AlamofireImage or another similar framework in a real project
        /*if let url = task.pictureUrl, let data = try? Data(contentsOf: url) {
         userImageView.image = UIImage(data: data)
         } else {
         userImageView.image = UIImage(named: "placeholder")
         }*/
        taskImageView.image = UIImage(named: task.imagePath)
        
    }

}
