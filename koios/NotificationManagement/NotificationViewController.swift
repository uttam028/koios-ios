//
//  AppCenterViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/4/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import CoreData

class NotificationViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //self.tableView.register(AppCenterIconCell.self, forCellReuseIdentifier: "appcentericoncell")
        self.tableView.register(UINib(nibName: "NotificationViewCell", bundle: nil), forCellReuseIdentifier: "notificationcell")

        //self.tableView.register(BubblePageViewCell.self, forCellReuseIdentifier: "bubblepageviewcell")

        //self.tableView.allowsMultipleSelectionDuringEditing = true
        tableView.tableFooterView = UIView()

        DispatchQueue.global(qos: .background).async {
            //for i in 0..<5{
                //Utils.generateSystemNotification(message: "This is generated from system")
            //}
            
            //Syncer.sharedInstance.insertDummyNotifications()
            //Syncer.sharedInstance.printAppNotifications(notificationList: Syncer.sharedInstance.getDummyNotifications())
        }
        
        
        initializeFetchedResultsController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //tabBarController?.tabBar.isHidden = true
        //self.extendedLayoutIncludesOpaqueBars = true
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            //self.tableView.beginUpdates()
            //self.tableView.endUpdates()
        }

    }
    
    func initializeFetchedResultsController() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppNotification")
        let latestSort = NSSortDescriptor(key: "originatedTime", ascending: false)
        let idSort = NSSortDescriptor(key: "notificationId", ascending: true)
        request.sortDescriptors = [latestSort, idSort]
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedBackgroundContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            print("fetched successfully")
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
    /*
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
        
    }
    */
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        print("change in section...")
        /*
        switch type {
        case .insert:
            print("section inserted...")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("section deleted...")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            print("section moved...")
            break
        case .update:
            print("section updated...")
            break
        }*/
    }


    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("change in row.. \(indexPath).\(indexPath?.section), \(indexPath?.row)")
            switch type {
            case .insert:
                print("new row inserted...")
                //tableView.insertRows(at: [IndexPath(row: (indexPath?.row)!, section: 1)], with: .fade)
                tableView.insertRows(at: [indexPath!], with: .fade)
            case .delete:
                print("row deleted...")
                //tableView.deleteRows(at: [IndexPath(row: (indexPath?.row)!, section: 1)], with: .fade)
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                print("row updated...")
                //tableView.reloadRows(at: [IndexPath(row: (indexPath?.row)!, section: 1)], with: .fade)
                tableView.reloadRows(at: [indexPath!], with: .fade)
            case NSFetchedResultsChangeType(rawValue: 3)!:
                print("update row by raw value")
                //tableView.reloadRows(at: [IndexPath(row: (indexPath?.row)!, section: 1)], with: .fade)
                tableView.reloadRows(at: [indexPath!], with: .fade)
            case .move:
                print("row moved...")
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            }
                

    }
    /*
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            print("will end update and reload")
            self.tableView.endUpdates()
            self.tableView.reloadData()
            print("ended and reloaded...")

        }
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else{
            return 0
        }
        print("number of rows in section: \(fetchedObjects.count)")
        return fetchedObjects.count
    }

    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else{
            return "Notifications"
        }
        if fetchedObjects.count == 0{
            return ""
        }
        return "Notifications(\(fetchedObjects.count))"
    }*/

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height
        if height < 600{
            return 80
        } else if height < 700{
            return 90
        } else{
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationcell", for: indexPath) as! NotificationViewCell
        
        //guard let object = self.fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0))   else {
        guard let object = self.fetchedResultsController?.object(at: indexPath)   else {
            fatalError("Attempt to configure cell without a managed object")
        }

        cell.titleLabel.text = (object as! AppNotification).title
        cell.messageLabel.text = (object as! AppNotification).message
        if (object as! AppNotification).viewCount > 0{
            cell.titleLabel.font = UIFont.systemFont(ofSize: cell.titleLabel.font.pointSize, weight: .regular)
            cell.messageLabel.font = UIFont.systemFont(ofSize: cell.messageLabel.font.pointSize, weight: .light)
            cell.backgroundColor = UIColor.groupTableViewBackground
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Notification", bundle: nil).instantiateViewController(withIdentifier: "notificationdetailsvc") as? NotificationDetailsViewController {
            
             //guard let object = self.fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0)) else {
            guard let object = self.fetchedResultsController?.object(at: indexPath) else {
                fatalError("Attempt to configure cell without a managed object")
             }
            viewController.selectedNotification = object as! AppNotification
            if let navigator = navigationController {
                print("program comes did row select")
                navigator.pushViewController(viewController, animated: true)
            }
        }

    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "Delete", handler: { (action, view, completion) in
            //TODO: Delete
            //guard let object = self.fetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0)) else {
            guard let object = self.fetchedResultsController?.object(at: indexPath) as! AppNotification? else {
                fatalError("Attempt to configure cell without a managed object")
            }

            if object.viewCount == 0{
                Utils.decreaseNotificationBadge()
            }
            Syncer.sharedInstance.deleteNotification(appNotification: object)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            completion(true)
        })
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UISwipeActionsConfiguration(actions: [])
        swipeAction.performsFirstActionWithFullSwipe = false // This is the line which disables full swipe
        return swipeAction
    }
    

    /*
    func taskIconTapped(_ sender: AppCenterIconCell) {
        print("task icon tapped")
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "taskicontappednotification"), object: nil, userInfo: nil)
        // `default` is now a property, not a method call
    }
    
    func contextIconTapped(_ sender: AppCenterIconCell) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contexticontappednotification"), object: nil, userInfo: nil)
    }
    */
    
}
