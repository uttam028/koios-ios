//
//  Utils.swift
//  cimonv2
//
//  Created by Afzal Hossain on 2/13/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

let headers: HTTPHeaders = [
    "secret": "koiosByAfzalFromNDmL@b"
]

class Utils: NSObject {
    
    // Mark: Dictionary functions
    
    /**
     A static function to save data to user default dictionary. This dictionary should be used in limited manner. Values that are related to user.
     
     Parameters: data (any type), string key
     */
    static func saveDataToUserDefaults(data:Any, key:String){
        UserDefaults.standard.set(data, forKey: key)
    }
    
    /**
     A static method to retrieve data from user defaults dictionary. Data was saved in Any type, so it is caller's responsibility to cast properly.
     Parameters: string key
     */
    static func getDataFromUserDefaults(key:String)->Any?{
        return UserDefaults.standard.object(forKey: key)
    }
    
    /**
     */
    static func removeDataFromUserDefault(key:String){
        UserDefaults.standard.removeObject(forKey:key)
    }
    
    //Mark: Date, Time
    
    @objc static func currentUnixTime() -> Int64{
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    static func currentUnixTimeUptoSec() -> Int64{
        return Int64(NSDate().timeIntervalSince1970)
    }
    static func currentLocalTime()-> String{
        let dateFormatter:DateFormatter? = DateFormatter()
        dateFormatter!.dateFormat = "yyyy-MM-dd HH:mm:ss SSSS ZZZ"
        if let currentTime = dateFormatter!.string(from: NSDate() as Date) as String?{
            return currentTime
        } else{
            return ""
        }
    }
    
    static func stringFromDateTime(date:Date!)->String{
        if let inputDate = date{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: inputDate)
        }
        return ""
    }
    
    static func stringFromDate(date:Date!)->String{
        if let inputDate = date{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: inputDate)
        }
        return ""
    }
    
    static func dateFromString(str:String!)->Date?{
        if let inputDate = str{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: inputDate)
        }
        return nil
    }
    
    //MARK: default values
    static var defaultOrganization:String{
        return "University of Notre Dame"
    }
    
    // Mark: Web services
    /**
     */
    static func getBaseUrl()->String{
        //return "http://129.74.247.110/cimoninterface/"
        return "https://koiosplatform.com/cimoninterface/"
    }
    
    // Mark: device
    static func getDeviceIdentifier()->String{
        let uuid:String = (UIDevice.current.identifierForVendor?.uuidString)!
        return uuid
    }
    
    static func getAppDisplayName()->String{
        
        if let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String{
            return displayName
        }
        return "System"
    }
    
    
    //Mark: plist file
    
    //load dictionary from plist file
    static func loadPlistData(plistFileName:String?)->NSMutableDictionary {
        
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent(plistFileName! + ".plist")
        
        let fileManager = FileManager.default
        //fileManager.removeItemAtPath(path, error: nil)
        
        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: plistFileName, ofType: "plist") {
                
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle state.plist file is --> \(String(describing: resultDictionary?.description))")
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                    
                } catch let error as NSError{
                    print("an error occured..\(error)")
                }
                print("copy")
            } else {
                print("state.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("state.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Loaded state.plist file is --> \(String(describing: resultDictionary?.description))")
        return resultDictionary!
    }
    
    
    static func getMappedValue(dict:NSMutableDictionary?, key:String?)->AnyObject!{
        if(dict != nil){
            return dict?.value(forKey: key!) as AnyObject?
        }
        return nil
    }
    
    
    
    //Mark: notification
    static func generateSystemNotification(message:String){
        let time = Date().timeIntervalSince1970
        let notifStruct:AppNotificationStruct = AppNotificationStruct(notificationId: Int64(time), originatedSource: getAppDisplayName(), originatedTime: String(time), title: getAppDisplayName(), message: message, loadingTime: String(time), loadingTimeZone: String(time), deleteOnView: 1, expiry: 12 * 60 * 60, viewCount: 0)
        Syncer.sharedInstance.insertNotification(notifStruct: notifStruct)
        increaseNotificationBadge()
    }
    static func generateSystemNotification(message:String, playSound:Bool){
        let time = Date().timeIntervalSince1970
        let notifStruct:AppNotificationStruct = AppNotificationStruct(notificationId: Int64(time), originatedSource: getAppDisplayName(), originatedTime: String(time), title: getAppDisplayName(), message: message, loadingTime: String(time), loadingTimeZone: String(time), deleteOnView: 1, expiry: 12 * 60 * 60, viewCount: 0)
        Syncer.sharedInstance.insertNotification(notifStruct: notifStruct)
        increaseNotificationBadge()
        if playSound{
            // create a sound ID, in this case its the tweet sound.
            let systemSoundID: SystemSoundID = 1016
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    static func increaseNotificationBadge(){
        let userInfo = [ "offset" : 1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatenotification"), object: nil, userInfo: userInfo)
        print("going to call increase notification")
        
    }
    
    static func decreaseNotificationBadge(){
        let userInfo = [ "offset" : -1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatenotification"), object: nil, userInfo: userInfo)
        
    }
    
    static func uploadLabelData(labelTime:String, label:String, labelType:String){
        let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
        let uuid:String = Utils.getDeviceIdentifier()
        
        
        //for all study, upload the same label, in future label will be part of the study
        
        for localStudy in Syncer.sharedInstance.getAllStudies(){
            var serviceUrl = Utils.getBaseUrl() + "study/labeling/history?id=\(localStudy.studyId)&email=\(email)&uuid=\(Utils.getDeviceIdentifier())&label_time=\(labelTime)&label=\(label)&label_type=\(labelType)"
            serviceUrl = serviceUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            print("ping url \(serviceUrl)")
            Alamofire.request(serviceUrl, headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value as Any)
                    let responseStruct = Response.responseFromJSONData(jsonData: json)
                    print("response after object : \(responseStruct.code), \(responseStruct.message)")
                    if responseStruct.code == 0{
                        //do nothing
                    } else{
                        //write in app error log
                    }
                case .failure(let error):
                    print("error in ping: \(error.localizedDescription)")
                    // TODO: show error label - service not available
                    //write in app error log
                }
            }
            
            
        }
    }
    
    
    static func uploadTokenIfRequired(){
        if let fcmStatus = Utils.getDataFromUserDefaults(key: "is_fcm_token_uploaded") as! String?{
            if fcmStatus == "true" {
                // no action required
                print("fcm token uploaded, no action required")
            }else{
                print("fcm token will be uploaded...")
                uploadToken()
            }
        }else{
            print("This should not be reached from the code")
        }
        
    }
    
    static func uploadToken(){
        if let email:String = Utils.getDataFromUserDefaults(key: "email") as! String?{
            if let fcmToken = Utils.getDataFromUserDefaults(key: "fcm_token") as! String?{
                var deviceToken = ""
                if let deviceTokenInStore = Utils.getDataFromUserDefaults(key: "device_token") as! String?{
                    deviceToken = deviceTokenInStore
                }
                
                var serviceUrl = Utils.getBaseUrl() + "device/fcm?email=\(email)&uuid=\(Utils.getDeviceIdentifier())&fcm_token=\(fcmToken)&device_token=\(deviceToken)"
                serviceUrl = serviceUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
                print("fcm url \(serviceUrl)")
                Alamofire.request(serviceUrl, headers: headers).validate().responseJSON { response in
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value as Any)
                        let responseStruct = Response.responseFromJSONData(jsonData: json)
                        print("response after object : \(responseStruct.code), \(responseStruct.message), \(serviceUrl)")
                        if responseStruct.code == 0{
                            Utils.saveDataToUserDefaults(data: "true", key: "is_fcm_token_uploaded")
                        } else{
                            Utils.saveDataToUserDefaults(data: "false", key: "is_fcm_token_uploaded")
                        }
                    case .failure(let error):
                        print("error in ping: \(error.localizedDescription)")
                        // TODO: show error label - service not available
                        Utils.saveDataToUserDefaults(data: "false", key: "is_fcm_token_uploaded")
                    }
                }
            }
            
        }
        
    }
    
}



