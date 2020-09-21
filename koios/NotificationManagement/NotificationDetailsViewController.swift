//
//  NotificationDetailsViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/6/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {

    var selectedNotification:AppNotification!
    var senderLabel:UILabel!
    var messageLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        
        senderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        senderLabel.font = UIFont.systemFont(ofSize: 20)
        senderLabel.textColor = UIColor(red: 0, green: 0.7804, blue: 0.902, alpha: 1.0) /* #00c7e6 */
        senderLabel.text = selectedNotification.title
        senderLabel.textAlignment = .center
        //senderLabel.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.numberOfLines = 0
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textColor = UIColor.black
        messageLabel.text = selectedNotification.message
        messageLabel.textAlignment = .center
        //messageLabel.sizeToFit()
        //messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        
        self.view.addSubview(senderLabel)
        self.view.addSubview(messageLabel)
        
        /*
        let verticalStackView = UIStackView(arrangedSubviews: [senderLabel, messageLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 15
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(verticalStackView)*/
        
        /*
        let viewsDictionary = ["sender":senderLabel, "message":messageLabel]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[sender]-15-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_H1 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[message]-15-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[sender]-15-[message]-20-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.view.addConstraints(stackView_V)
        self.view.addConstraints(stackView_H)
        self.view.addConstraints(stackView_H1)
        */
 
        if selectedNotification.deleteOnView == 1{
            Utils.decreaseNotificationBadge()
            Syncer.sharedInstance.deleteNotification(appNotification: self.selectedNotification)
        }else{
            if selectedNotification.viewCount == 0{
                Utils.decreaseNotificationBadge()
            }
            Syncer.sharedInstance.updateViewCount(appNotification: selectedNotification)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteNotification(_ sender: Any) {
        print("delete button clicked....")
        Syncer.sharedInstance.deleteNotification(appNotification: self.selectedNotification)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


