//
//  ActiveSurveyListViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 2/27/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import CoreData

class ActiveTasksGroupViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFetchedResultsController()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.extendedLayoutIncludesOpaqueBars = false

        Syncer.sharedInstance.syncStudies()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    func initializeFetchedResultsController() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Survey")
        let idSort = NSSortDescriptor(key: "surveyId", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [idSort, nameSort]
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedBackgroundContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "surveyId", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
    /*
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }*/
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        print("change in section...\(type.rawValue)")
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
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("change in row...\(type.rawValue)")

        switch type {
        case .insert:
            print("new row inserted...")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("row deleted...")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("row updated...")
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case NSFetchedResultsChangeType(rawValue: 3)!:
            print("update row by raw value")
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            print("row moved...")
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    /*
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }*/
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections


//        return fetchedResultsController.sections!.count
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 1
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activetaskcell", for: indexPath) as! ActiveTasksViewCell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        cell.nameLabel.text = (object as! Survey).name
        cell.descLabel.text = (object as! Survey).studyName
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Task", bundle: nil).instantiateViewController(withIdentifier: "tasklistvc") as? TaskListViewController {
            guard let object = self.fetchedResultsController?.object(at: indexPath) else {
                fatalError("Attempt to configure cell without a managed object")
            }
            viewController.studyId = (object as! Survey).studyId
            viewController.surveyId = (object as! Survey).surveyId
            //print("study \(viewController.studyId), survey \(viewController.surveyId), index \(indexPath.section)")
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
