//
//  TaskListViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 3/3/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Eureka
import CoreData

class TaskListViewController: FormViewController, ChildTaskViewControllerDelegate {
    var studyId:Int32 = 0
    var surveyId:Int32 = 0
    var version:Int16 = 0
    var taskList:[Task] = []
    var surveyResponse:[SurveyResponse] = []
    var referenceDict = Dictionary<Int, String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clearAllResponses()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitForm))

        taskList = Syncer.sharedInstance.getAllTasks(studyId: studyId, surveyId: surveyId)
        
        for i in 0..<taskList.count{
            var quesString = "Q. "
            let type:String = taskList[i].type!
            let task = taskList[i]
            /*if type.lowercased() == "text"{
                let sectionTag = "\(i)_\(type)"
                let rowTag = sectionTag.appending("_row")
                form +++ Section(){ section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.tag = sectionTag
                }
                <<< TextRow(){row in
                    row.placeholder = "Type your answer"
                    row.tag = rowTag
                }
                
            }else if type.lowercased() == "textarea"{
                let sectionTag = "\(i)_\(type)"
                let rowTag = sectionTag.appending("_row")
                form +++ Section(){ section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.tag = sectionTag
                }
                <<< TextAreaRow(){row in
                    row.placeholder = "Type your answer"
                    row.tag = rowTag
                }
            }else if type.lowercased() == "date"{
                let sectionTag = "\(i)_\(type)"
                let rowTag = sectionTag.appending("_row")

                form +++ Section(){ section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.tag = sectionTag
                }
                <<< DateRow(){row in
                    row.value = Date(timeIntervalSinceNow: 0)
                    row.tag = rowTag
                }

            }else if type.lowercased() == "selection"{
                let sectionTag = "\(i)_\(type)"
                form +++ SelectableSection<ImageCheckRow<String>>() { section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.tag = sectionTag
                }
                let availableOptions = task.possibleInput!.split(separator: "|")
                for item in availableOptions {
                    let option = String(item)
                    form.last! <<< ImageCheckRow<String>(option){ lrow in
                        lrow.title = option
                        lrow.selectableValue = option
                        lrow.value = nil
                    }
                }

                
            }else if type.lowercased() == "choice"{
                let sectionTag = "\(i)_\(type)"
                form +++ SelectableSection<ImageMultipleCheckRow<String>>() { section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.selectionType = SelectionType.multipleSelection
                    section.tag = sectionTag
                }
                let availableOptions = task.possibleInput!.split(separator: "|")
                for item in availableOptions {
                    let option = String(item)
                    form.last! <<< ImageMultipleCheckRow<String>(option){ lrow in
                        lrow.title = option
                        lrow.selectableValue = option
                        lrow.value = nil
                    }
                }
                
                
            }else*/ if type.contains(s: "MT001"){
                print("task type: \(taskList[i].type)")
                var instString = "Tap to Start"
                if(task.isRequired>0){
                    instString = "*".appending(instString)
                }
                form +++ Section(instString){section in
                        section.tag = "\(i)_motortask"
                    }
                    <<< MotorTaskPresenterRow() { row in
                        row.value = MotorTask(type: "", imagePath: "signature")
                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                            let storyBoard = UIStoryboard(name: "Task", bundle: nil)
                            let controller = storyBoard.instantiateViewController(withIdentifier: "signaturetaskvc") as! MotorTaskViewController
                            controller.indexInParent = i
                            controller.delegate = self
                            //controller.delegate = row
                            return controller
                            }, onDismiss: { vc in
                                _ = vc.navigationController?.popViewController(animated: true)
                        })
                    }

            } else if type.contains(s: "MT002"){
                print("task type: \(taskList[i].type)")
                var instString = "Tap to Start"
                if(task.isRequired>0){
                    instString = "*".appending(instString)
                }
                form +++ Section(instString){section in
                        section.tag = "\(i)_motortask"
                    }
                    <<< MotorTaskPresenterRow() { row in
                        row.value = MotorTask(type: "", imagePath: "memory")
                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                            let storyBoard = UIStoryboard(name: "Task", bundle: nil)
                            let controller = storyBoard.instantiateViewController(withIdentifier: "memorytaskvc") as! MotorTaskViewController
                            controller.delegate = self
                            //controller.delegate = row
                            return controller
                            }, onDismiss: { vc in
                                _ = vc.navigationController?.popViewController(animated: true)
                        })
                }
                
            } else if type.contains(s: "MT003"){
                print("task type: \(taskList[i].type)")
                var instString = "Tap to Start"
                if(task.isRequired>0){
                    instString = "*".appending(instString)
                }
                form +++ Section(instString){section in
                        section.tag = "\(i)_motortask"
                    }
                    <<< MotorTaskPresenterRow() { row in
                        row.value = MotorTask(type: "", imagePath: "balance")
                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                            let storyBoard = UIStoryboard(name: "Task", bundle: nil)
                            let controller = storyBoard.instantiateViewController(withIdentifier: "balancetaskvc") as! MotorTaskViewController
                            controller.indexInParent = i
                            controller.delegate = self
                            //controller.delegate = row
                            return controller
                            }, onDismiss: { vc in
                                _ = vc.navigationController?.popViewController(animated: true)
                        })
                }
                
            } else if type.contains(s: "MT005"){
                print("task type: \(taskList[i].type)")
                var instString = "Tap to Start"
                if(task.isRequired>0){
                    instString = "*".appending(instString)
                }
                form +++ Section(instString){section in
                    section.tag = "\(i)_motortask"
                    }
                    <<< MotorTaskPresenterRow() { row in
                        row.value = MotorTask(type: "", imagePath: "grossmotor")
                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                            let storyBoard = UIStoryboard(name: "Task", bundle: nil)
                            let controller = storyBoard.instantiateViewController(withIdentifier: "grossmotortaskvc") as! MotorTaskViewController
                            controller.indexInParent = i
                            controller.delegate = self
                            //controller.delegate = row
                            return controller
                            }, onDismiss: { vc in
                                _ = vc.navigationController?.popViewController(animated: true)
                        })
                }
                
            } else if type.contains(s: "MT010"){
                print("task type: \(taskList[i].type)")
                var instString = "Tap to Start"
                if(task.isRequired>0){
                    instString = "*".appending(instString)
                }
                form +++ Section(instString){section in
                    section.tag = "\(i)_motortask"
                    }
                    <<< MotorTaskPresenterRow() { row in
                        row.value = MotorTask(type: "", imagePath: "visuospatial")
                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                            let storyBoard = UIStoryboard(name: "Task", bundle: nil)
                            let controller = storyBoard.instantiateViewController(withIdentifier: "visuospatialvc") as! MotorTaskViewController
                            controller.indexInParent = i
                            controller.delegate = self
                            //controller.delegate = row
                            return controller
                            }, onDismiss: { vc in
                                _ = vc.navigationController?.popViewController(animated: true)
                        })
                }
                
            }else if type.contains(s: "MT011"){
                print("task type: \(taskList[i].type)")
                var instString = "Tap to Start"
                if(task.isRequired>0){
                    instString = "*".appending(instString)
                }
                form +++ Section(instString){section in
                    section.tag = "\(i)_motortask"
                    }
                    <<< MotorTaskPresenterRow() { row in
                        row.value = MotorTask(type: "", imagePath: "color")
                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                            let storyBoard = UIStoryboard(name: "Task", bundle: nil)
                            let controller = storyBoard.instantiateViewController(withIdentifier: "colorgamevc") as! MotorTaskViewController
                            controller.indexInParent = i
                            controller.delegate = self
                            //controller.delegate = row
                            return controller
                            }, onDismiss: { vc in
                                _ = vc.navigationController?.popViewController(animated: true)
                        })
                }
                
            }else if type.contains(s: "MT014"){
                print("task type: \(taskList[i].type)")
                var instString = "Tap to Start"
                if(task.isRequired>0){
                    instString = "*".appending(instString)
                }
                form +++ Section(instString){section in
                    section.tag = "\(i)_motortask"
                    }
                    <<< MotorTaskPresenterRow() { row in
                        row.value = MotorTask(type: "", imagePath: "target")
                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                            let storyBoard = UIStoryboard(name: "Task", bundle: nil)
                            let controller = storyBoard.instantiateViewController(withIdentifier: "targettaskvc") as! MotorTaskViewController
                            controller.indexInParent = i
                            controller.delegate = self
                            //controller.delegate = row
                            return controller
                            }, onDismiss: { vc in
                                _ = vc.navigationController?.popViewController(animated: true)
                        })
                }
                
            }

        }
    }
    
    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = .black
            if(view.textLabel?.text?.hasPrefix("*"))!{
                view.textLabel?.textColor = UIColor(hue: 0.4917, saturation: 0.86, brightness: 0.65, alpha: 1.0)
            }
        }
    }

    
    @objc func submitForm(){
        
        var surveyResponses:[SurveyResponseStruct] = []
        for i in 0..<form.allSections.count{
            print("row number \(i).....\(String(describing: form.allSections[i].tag))")
            var response = ""
            var responseType = "value"
            if let sectionTag = form.allSections[i].tag {
                let tagTokens = sectionTag.split(separator: "_")
                let taskIndex:Int = Int(tagTokens[0])!
                if tagTokens.count > 1{
                    
                    let taskType = tagTokens[1].lowercased()
                    
                    if taskType == "text"{
                        let row:TextRow = form.rowBy(tag: "\(sectionTag)_row")!
                        if let temp = row.value{
                            response = temp.trim()
                        }
                        if (response.length == 0 && taskList[taskIndex].isRequired == 1){
                            return
                        }
                    }else if taskType == "textarea"{
                        let row:TextAreaRow = form.rowBy(tag: "\(sectionTag)_row")!
                        if let temp = row.value{
                            response = temp.trim()
                        }
                        if (response.length == 0 && taskList[taskIndex].isRequired == 1){
                            return
                        }
                    }else if taskType == "date"{
                        let row:DateRow = form.rowBy(tag: "\(sectionTag)_row")!
                        response = Utils.stringFromDate(date: row.value)
                        if (response.length == 0 && taskList[taskIndex].isRequired == 1){
                            return
                        }

                    }else if taskType == "selection"{
                        let section  = form.sectionBy(tag: sectionTag) as! SelectableSection<ImageCheckRow<String>>
                        //print("select value:\(section?.selectedRows().map({$0.value!}))")
                        let answers:[String] = section.selectedRows().map({$0.value!})
                        for j in 0..<answers.count{
                            response = response.appending("\(answers[j])")
                        }
                        if response.hasSuffix("_"){
                            response = String(response.dropLast())
                        }

                    }else if taskType == "choice"{
                        let section  = form.sectionBy(tag: sectionTag) as! SelectableSection<ImageMultipleCheckRow<String>>
                        //print("select value:\(section?.selectedRows().map({$0.value!}))")
                        let answers:[String] = section.selectedRows().map({$0.value!})
                        for j in 0..<answers.count{
                            response = response.appending("\(answers[j])")
                        }
                        if response.hasSuffix("_"){
                            response = String(response.dropLast())
                        }

                    }else if taskType == "motortask"{
                        responseType = "reference"
                    }
                }
                surveyResponses.append(SurveyResponseStruct(studyId: self.studyId, surveyId: self.surveyId, taskId: self.taskList[taskIndex].taskId, version: self.version, submissionTime: /*String(Date().timeIntervalSince1970)*/"", submissionTimeZone: "", answerType: responseType, answer: response, comment: "", objectUrl: ""))
            }
        }
        let context:NSManagedObjectContext = self.getContext()
        for i in 0..<surveyResponses.count{
            let newResponse:SurveyResponse = NSEntityDescription.insertNewObject(forEntityName: "SurveyResponse", into: context) as! SurveyResponse
            
            newResponse.studyId = surveyResponses[i].studyId
            newResponse.surveyId = surveyResponses[i].surveyId
            newResponse.taskId = surveyResponses[i].taskId
            newResponse.version = surveyResponses[i].version
            newResponse.submissionTime = surveyResponses[i].submissionTime
            newResponse.submissionTimeZone = surveyResponses[i].submissionTimeZone
            newResponse.answerType = surveyResponses[i].answerType
            newResponse.answer = surveyResponses[i].answer
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                print("error while saving context")
            }
        }
        //printAllResponses(responses: getAllResponses())
        //print("total rows: \(getAllResponses().count)")
        Syncer.sharedInstance.uploadSurveyResponses()
        self.navigationController?.popViewController(animated: true)

    }
    
    private func getContext()->NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).managedBackgroundContext
    }
    
    func getAllResponses()->[SurveyResponse]!{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SurveyResponse")
        //fetchRequest.predicate = NSPredicate(format: "studyId = %d", studyId)
        do{
            return try getContext().fetch(fetchRequest) as! [SurveyResponse]
        } catch let error as NSError{
            print("error:\(error)")
            return nil
        }
        
    }
    
    func clearAllResponses(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SurveyResponse")
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try getContext().execute(request)
            try getContext().save()
        } catch {
            print("error while deleting...")
        }
    }
    
    func printAllResponses(responses:[SurveyResponse]){
        for response in responses{
            print("study id:\(response.studyId), survey id:\(response.surveyId), task id:\(response.taskId), version:\(response.version), submission time:\(response.submissionTime), time zone:\(response.submissionTimeZone), answer type:\(response.answerType), answer:\(response.answer)")
        }
    }

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func childViewControllerResponse(refernceAnswer: String) {
        print("reference answer: \(refernceAnswer)")
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



protocol ChildTaskViewControllerDelegate
{
    func childViewControllerResponse(refernceAnswer:String)
}


