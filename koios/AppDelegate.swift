//
//  AppDelegate.swift
//  koios
//
//  Created by Afzal Hossain on 8/7/20.
//  Copyright © 2020 Afzal Hossain. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                //Initialize window
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var initialViewController:UIViewController? = nil
            if let signedup = Utils.getDataFromUserDefaults(key: "signedup") as! Bool?{
                print("signed up value: \(signedup)")
                if let email:String = Utils.getDataFromUserDefaults(key: "email") as! String?{
                    if signedup{
                        initialViewController = storyBoard.instantiateViewController(withIdentifier: "ApplicationStory")
                    } else{
                        //signedup nil: signup, signedup false: verfication, signed up: app home
                        initialViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyTokenStory")
                    }
                } else{
                    initialViewController = storyBoard.instantiateViewController(withIdentifier: "SignupStory")
                }
            } else{
                initialViewController = storyBoard.instantiateViewController(withIdentifier: "SignupStory")
            }
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
            
            //sensor core engine
            KeepAliveByLocationManager.sharedInstance.startLocationToKeepAlive()
            SensorDataCollector.sharedInstance.startCoreSensing()
            
//            FileUploader().uploadDataFile()
        
        
            FirebaseApp.configure()
            Messaging.messaging().delegate = self
        
            registerForPushNotifications()
            return true
    }

    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        
        if let fcmTokenInStore = Utils.getDataFromUserDefaults(key: "fcm_token") as! String?{
            if fcmToken == fcmTokenInStore{
                //no action required
                print("Token same, no action required")
            }else{
                //new fcm token
                print("new fcm token, diff from stored one, status set to false, and update token")
                Utils.saveDataToUserDefaults(data: "false", key: "is_fcm_token_uploaded")
                Utils.saveDataToUserDefaults(data: fcmToken, key: "fcm_token")
            }
        }else{
            //new fcm token
            print("not any stored token, new fcm token, status set to false, and update token")
            Utils.saveDataToUserDefaults(data: "false", key: "is_fcm_token_uploaded")
            Utils.saveDataToUserDefaults(data: fcmToken, key: "fcm_token")
        }
        
        Utils.uploadTokenIfRequired()
        
    }

    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    

    // MARK: - Core Data stack
    
    
    lazy var managedObjectViewContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    lazy var managedBackgroundContext: NSManagedObjectContext = {
        let container = self.persistentContainer

        return container.newBackgroundContext()
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "koios")
        /*add necessary support for migration*/
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        /*add necessary support for migration*/
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveViewContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

