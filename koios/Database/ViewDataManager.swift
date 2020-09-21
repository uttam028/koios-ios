//
//  DataManager.swift
//  cimonv2
//
//  Created by Afzal Hossain on 3/18/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import Foundation
import CoreData

class ViewDataManager: NSObject {
    static let sharedInstance = ViewDataManager()
    var context: NSManagedObjectContext!
    
    override init() {
        super.init()
        context = (UIApplication.shared.delegate as! AppDelegate).managedObjectViewContext
    }

    func saveContext(){
        (UIApplication.shared.delegate as! AppDelegate).saveViewContext()
    }
    /*
    func getActiveSurveys()->[SurveyStruct]{
        var activeSurveys = [SurveyStruct]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Survey")
        do{
            let surveys:[Survey] = try context.fetch(fetchRequest) as! [Survey]
            for survey in surveys{
                activeSurveys.append(SurveyStruct.surveyStructFromManagedObject(survey: survey))
            }
        } catch let error as NSError{
            print("error:\(error)")
        }
        print("length of active list:\(activeSurveys.count)")
        return activeSurveys
    }*/

}
