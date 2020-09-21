//
//  AppTabController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 3/19/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class AppTabController: UITabBarController, UITabBarControllerDelegate {

    fileprivate let notificationTabIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.unselectedItemTintColor = UIColor.white
        
        //DispatchQueue.global().async {
            self.synData()
        //}
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotificationBadge(_:)), name: NSNotification.Name(rawValue: "updatenotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.enrollToStudy(_:)), name: NSNotification.Name(rawValue: "enrolledtostudy"), object: nil)

        
    }
    
    override func viewDidLayoutSubviews() {
        let notificationBadge = Syncer.sharedInstance.getUnreadNotificationCount()
        print("get unread count \(notificationBadge)")
        if notificationBadge > 0{
            self.setNotificationBadge(value: notificationBadge)
        }
    }

    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        print("app comes into foreground...")
//        DispatchQueue.main.async {
            self.synData()
//        }
        
    }

    @objc func enrollToStudy(_ notification: NSNotification) {
        
        self.selectedIndex = 0
        
        guard let studyId = notification.userInfo?["studyId"] as? Int32 else { return }
        guard let studyName = notification.userInfo?["studyName"] as? String else { return }
        Syncer.sharedInstance.syncSurveysOfStudy(studyId: studyId, studyName: studyName)
        //Utils.generateSystemNotification(message: "Thank you for joining to the \(studyName).", playSound: true)

    }

    
    func synData(){
        Syncer.sharedInstance.syncStudies()
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNotificationBadge(value:Int){
        DispatchQueue.main.async {
            self.tabBar.items?[self.notificationTabIndex].badgeValue = "\(value)"
        }
    }
    
    @objc func updateNotificationBadge(_ notification: NSNotification){
        print("receive notif in tabbar")
        var offset = 0
        if let offsetInfo = notification.userInfo?["offset"] as? Int{
            offset = offsetInfo
        }
        print("offset value..")
        if let previous = Int((self.tabBar.items?[notificationTabIndex].badgeValue)!){
            let nextValue = previous + offset
            if nextValue <= 0{
                DispatchQueue.main.async {
                    self.tabBar.items?[self.notificationTabIndex].badgeValue = nil
                }
            }else{
                DispatchQueue.main.async {
                    self.tabBar.items?[self.notificationTabIndex].badgeValue = String(nextValue)
                }
            }
        }
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


//APP Badges
//unreadNotification
//
