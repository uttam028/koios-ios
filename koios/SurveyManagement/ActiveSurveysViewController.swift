//
//  ActiveSurveysGroupViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/19/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import CoreData

class ActiveSurveysViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
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
        print("is it called every time, then why result controller.....")
//        Syncer.sharedInstance.syncStudies()
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
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            print("section deleted...")
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move:
            print("section moved...")
        case .update:
            print("section updated...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("change in row...\(type.rawValue)")
        
        switch type {
        case .insert:
            print("new row inserted...")
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            print("row deleted...")
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            print("row updated...")
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        case NSFetchedResultsChangeType(rawValue: 3)!:
            print("update row by raw value")
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            print("row moved...")
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("ending update table view")
        tableView.endUpdates()
        tableView.reloadData()
     }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return surveys.count
        print("recaluclate section count\(fetchedResultsController.sections?.count)")
        return fetchedResultsController.sections!.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activesurveycell", for: indexPath) as! ActiveSurveysViewCell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        cell.nameLabel.text = (object as! Survey).name
        cell.descLabel.text = (object as! Survey).studyName
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Survey", bundle: nil).instantiateViewController(withIdentifier: "surveyvc") as? SurveyViewController {
            guard let object = self.fetchedResultsController?.object(at: indexPath) else {
                fatalError("Attempt to configure cell without a managed object")
            }
            viewController.studyId = (object as! Survey).studyId
            viewController.surveyId = (object as! Survey).surveyId
            viewController.version = (object as! Survey).version
            //print("study \(viewController.studyId), survey \(viewController.surveyId), index \(indexPath.section)")
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    
}
