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
        
//        reno - comment before special changes
//        cell.nameLabel.text = (object as! Survey).name
//        cell.descLabel.text = (object as! Survey).studyName
        
//        reno - special changes for first responder study
        
        
        // INITIALIZE DIFFERENCE IN DAYS TO -1 SO THAT ALL SURVEYS ARE INITIALLY RED
        var differenceInDays = -1
        if let date = UserDefaults.standard.object(forKey: String((object as! Survey).surveyId))
        {
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy HH:mm"
            print("heres", df.string(from: date as! Date))
            let current = Date()
            let differenceInSeconds = Int(current.timeIntervalSince(date as! Date))
            differenceInDays = Int(differenceInSeconds / (60 * 60 * 24));
            cell.nameLabel.text = "Completed: \(differenceInDays) day(s) ago"
            print("surveyName: \((object as! Survey).name), \((object as! Survey).surveyId)  \((object as! Survey).scheduleCode)")
            
            if differenceInDays > 1{
                cell.nameLabel.text = "Completed: \(differenceInDays) days ago"
            }
            else if differenceInDays == 1{
                cell.nameLabel.text = "Completed yesterday"
            }
            else if differenceInDays == 0{
                cell.nameLabel.text = "Completed today"
            }
        }
        else{
            print("Nothing yet")
            cell.nameLabel.text = "Not completed yet"
            
        }
        
        switch (object as! Survey).scheduleCode {
        case "always":

            // NOTE: Special case only for First Responder Emotion Study
            if (object as! Survey).surveyId == 22{ // dealing with follow-up
    
                // initialize text as black
                cell.nameLabel.textColor = .black
                
                
                var last3EventsCopy:[Any] = []
                // see if any event surveys have been completed
                if let last3Events = UserDefaults.standard.array(forKey: "23-last3responses"){ // get info on last time event survey was taken
                    
                    
                    last3EventsCopy = last3Events
                    
                    
                    // Determine if Follow-Up has been completed
                    var last3FollowUpsCopy:[Any] = []
                    if let last3FollowUps = UserDefaults.standard.array(forKey: "22-last3responses"){
                        last3FollowUpsCopy = last3FollowUps
                        
                    }
                    // no follow-up has been completed --> turn red
                    else{
                        cell.nameLabel.textColor = .red
                        break
                    }
                    
                    // for all responses in last3Events, mark them off with a follow-up
                    while !last3EventsCopy.isEmpty{
                        
                        // pop Event Survey from array
                        let event = last3EventsCopy.popLast()
                        let df = DateFormatter()
                        df.dateFormat = "dd/MM/yyyy HH:mm"
                        print("in queue", df.string(from: event as! Date))
                        let current = Date()
                        let differenceInSecondsEventSurvey = Int(current.timeIntervalSince(event as! Date))
                        let differenceInDaysEventSurvey = Int(differenceInSecondsEventSurvey / (60 * 60 * 24));
                        
                        // pop Follow-Up survey if possible, if not possible make text red
                        let followUp = last3FollowUpsCopy.popLast()
                        
                        
                        if followUp == nil{
                            cell.nameLabel.textColor = .red // no follow-up to match
                            break
                        }
                        else{
                            
                            // get info on Event Survey
                            let df2 = DateFormatter()
                            df2.dateFormat = "dd/MM/yyyy HH:mm"
                            print("in queue", df2.string(from: followUp as! Date))
                            let current2 = Date()
                            let differenceInSecondsFollowUpSurvey = Int(current2.timeIntervalSince(followUp as! Date))
                            let differenceInDaysFollowUpSurvey = Int(differenceInSecondsFollowUpSurvey / (60 * 60 * 24));
                            
                               
                            // if follow-up cannot account for event, make text red
                            if differenceInDaysEventSurvey > 0 && differenceInDaysEventSurvey < 3 &&
                                differenceInSecondsEventSurvey < differenceInSecondsFollowUpSurvey{
                                cell.nameLabel.textColor = .red
                                break
                            }
                            else{
                                cell.nameLabel.textColor = .black // accounted for
                                
                            }
                        }
                       
                        
                    }
                
                }
                    
                // no event surveys have been completed, remain black
                else{
                    cell.nameLabel.textColor = .black
                }

                
            }
        case "once":
            if differenceInDays == -1 {
                cell.nameLabel.textColor = .red
            }
        case let str where str!.contains("weekly"):
            if differenceInDays >= 7 || differenceInDays == -1{
                cell.nameLabel.textColor = .red
            }
        case let str where str!.contains("monthly"):
            if differenceInDays >= 31 || differenceInDays == -1{
                cell.nameLabel.textColor = .red
            }
        default:
            cell.nameLabel.textColor = .black
            print(((object as! Survey).scheduleCode))
        }
        
        cell.descLabel.text = (object as! Survey).name
//        reno - end of special implementation
        
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
