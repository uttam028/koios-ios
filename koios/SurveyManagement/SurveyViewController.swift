//
//  SurveyViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/19/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Eureka
import CoreData

class SurveyViewController: FormViewController, SurveyObjectVCDelegate, SurveyObjectPhotoVCDelegate {

    //studyId, surveyId, version is updated from ActiveSurveyViewController.swift
    var studyId:Int32 = 0
    var surveyId:Int32 = 0
    var version:Int16 = 0

    let queueLimit = 3

    var taskList:[Task] = []
    var surveyResponse:[SurveyResponse] = []
    var filePhotoResponseDict = Dictionary<String, String>()
    var fileResponseDict = Dictionary<String, String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        //clearAllResponses()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitClicked))

        taskList = Syncer.sharedInstance.getAllTasks(studyId: studyId, surveyId: surveyId)

        var decrementForHeaders = 0
        for i in 0..<taskList.count{
            var quesString = "Q \(i + 1 - decrementForHeaders). "
            print("comment:\(taskList[i].hasComment), q:\(taskList[i].text)")
            let type:String = taskList[i].type!
            let task = taskList[i]
            if type.lowercased() == "text"{
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
            }else if type.lowercased() == "instruction"{
                let sectionTag = "\(i)_\(type)"
                let rowTag = sectionTag.appending("_row")
                form +++ Section(){ section in
                    section.header = HeaderFooterView(title: task.text!)
                    section.tag = sectionTag
                    decrementForHeaders+=1;
                }
            }
            else if type.lowercased() == "date"{
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
                        //row.value = Date(timeIntervalSinceNow: 0)
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
                    
                    /*
                    ----- THIS IS AN EXAMPLE OF THE CONDITIONAL, HERE IS WHERE WE CODE A QUESTION TO BE DEPENDENT ON ANOTHER QUESTION  ------
                    var sectionDecidingNum = 18
                    if i == 17{
                        section.hidden = Condition.function([])
                        { form in
                            print("evaluation")
                            if let sectionDeciding = form.allSections[sectionDecidingNum] as? SelectableSection<ImageCheckRow<String>> {
                                if sectionDeciding.selectedRow()?.value == "No" {
                                    print("Removing...")
                                    return true
                                }
                            }
                            print("Adding...")
                            return false
                        }
                    }
                    */
                }
                let availableOptions = task.possibleInput!.split(separator: "|")
                var rowTag = 0
                for item in availableOptions {
                    let option = String(item)
                    form.last! <<< ImageCheckRow<String>(option){ lrow in
                        lrow.tag = "\(sectionTag)_\(rowTag)"
                        lrow.title = option
                        lrow.selectableValue = option
                        lrow.value = nil
                        rowTag = rowTag + 1
                      
                    
                        /*
                        ----- THIS IS WHERE THE QUESTION ANOTHER QUESTION DEPENDS ON IS EVALUATED TO DETERMINE IF THE QUESTION SHOULD BE HIDDEN -----
                        if i == 18{
                            lrow.onChange() {_   in
                                if let dependentSection = self.form.allSections[17] as? Section{
                                    dependentSection.evaluateHidden()
                                }
                            }
                        }
                        */
                        
                    }
                }
                if taskList[i].hasComment==1 {
                    form.last! <<< TextAreaRow() {row in
                        row.placeholder = "Type Any Comment"
                        row.tag = "\(sectionTag)_comment"
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
                if taskList[i].hasComment==1 {
                    form.last! <<< TextAreaRow() {row in
                        row.placeholder = "Type Any Comment"
                        row.tag = "\(sectionTag)_comment"
                    }
                }


            }else if type.lowercased() == "recording"{
                let sectionTag = "\(i)_\(type)"
                let rowTag = sectionTag.appending("_row")
                form +++ Section(){ section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.tag = sectionTag
                    }
                    <<< ButtonRow(){row in
                        row.title = "Click here to record"
                        row.onCellSelection {cell, row in
                            self.fileResponseDict[rowTag] = ""
                            let secondVC = RecordingController(studyId: self.studyId, surveyId: self.surveyId, taskId: self.taskList[i].taskId, version: self.version, objectKey: rowTag)
                            secondVC.delegate = self
                            self.navigationController?.pushViewController(secondVC, animated: true)
                            // fileForSubmission
                        }
                }
            }else if type.lowercased() == "photo"{
                let sectionTag = "\(i)_\(type)"
                let rowTag = sectionTag.appending("_row")
                form +++ Section(){ section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.tag = sectionTag
                    }
                    <<< ButtonRow(){row in
                        row.title = "Click here to upload a photo"
                        row.onCellSelection {cell, row in
                            self.filePhotoResponseDict[rowTag] = ""
                            let secondVC = PhotoContoller(studyId: self.studyId, surveyId: self.surveyId, taskId: self.taskList[i].taskId, version: self.version, objectKey: rowTag)
                            secondVC.delegate = self
                            self.navigationController?.pushViewController(secondVC, animated: true)
                            // fileForSubmission
                        }
                }
            }else if type.lowercased() == "rating"{
                let sectionTag = "\(i)_\(type)"
                let rowTag = sectionTag.appending("_row")
                form +++ Section(){ section in
                    if(task.isRequired>0){
                        quesString = "*".appending(quesString)
                    }
                    section.header = HeaderFooterView(title: quesString.appending(task.text!))
                    section.tag = sectionTag
                    }

                    <<< PickerInlineRow<String>() {(row : PickerInlineRow<String>) -> Void in
                        row.title = "Click here to answer"
                        row.tag = rowTag
                        row.options = []
                        let availableOptions = task.possibleInput!.split(separator: "|")
                        for item in availableOptions {
                            let option = String(item)
                            row.options.append(option)
                        }
                    }
            }else if type.lowercased() == "numeric"{
                  let sectionTag = "\(i)_\(type)"
                  let rowTag = sectionTag.appending("_row")
                  form +++ Section(){ section in
                      if(task.isRequired>0){
                          quesString = "*".appending(quesString)
                      }
                      section.header = HeaderFooterView(title: quesString.appending(task.text!))
                      section.tag = sectionTag
                      }

                      <<< IntRow() {(row : IntRow) -> Void in
                          row.title = "Click here to answer"
                          row.tag = rowTag
                      }
            }else if type.contains("likert"){  // either likert4, likert5, likert7
                
                // IN PRACTICE, THE TYPE WOULD INCLUDE 'preset' IF THE USER WANTS TO IGNORE THE CUSTOM OPTIONS AND INSTEAD USE THE PRESET OPTIONS AND INCLUDE 'legend' IF THE USER WANTS TO USE A LEGEND
                
                  let sectionTag = "\(i)_\(type)"
                  let rowTag = sectionTag.appending("_row")
                  var options = [] as [String]
                
                  // custom options
                  for item in task.possibleInput!.split(separator: "|") {
                      let option = String(item)
                      options.append(option)
                  }
                  
                
                  // change options to preset
                  if type.lowercased().contains("preset"){
                      if type.lowercased().contains("4"){
                          options = ["Strongly Disagree", "Somewhat Disagree", "Somewhat Agree", "Strongly Agree"]
                      }else if type.lowercased().contains("5"){
                          options = ["Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"]
                      }else if type.lowercased().contains("7"){
                          options = ["Strongly Disagree", "Disagree", "Partly Disagree", "Neutral", "Partly Agree", "Agree", "Strongly Agree"]
                      }
                  }
                  form +++ Section(){ section in
                       if(task.isRequired>0){
                           quesString = "*".appending(quesString)
                       }
                       section.header = HeaderFooterView(title: quesString.appending(task.text!))
                       section.tag = sectionTag
                  }
                
                  <<< SegmentedRow<String>(){ row in
                      row.tag = rowTag
                      var selectableOptions = options
                    
                      // use numbers as selectable options if legend is chosen
                      if type.lowercased().contains("legend"){
                          if type.lowercased().contains("4"){
                              selectableOptions = ["1", "2", "3", "4"]
                          }else if type.lowercased().contains("5"){
                              selectableOptions = ["1", "2", "3", "4", "5"]
                          }else if type.lowercased().contains("7"){
                              selectableOptions = ["1", "2", "3", "4", "5", "6", "7"]
                          }
                      }
                      row.options = options
                    
                      // alternate display for legend
                      row.displayValueFor = { String  in
                        return selectableOptions[options.firstIndex(of: String ?? "nil") ?? 0]
                      }
                      }.cellSetup{cell, row in
                    
                         
                          // reduce font size if there are 7 options without a legend
                          // Note: It is best to use a legend for 7 options
                          var fontSize = 14
                          if type.lowercased().contains("7") && !type.lowercased().contains("legend"){
                              fontSize = 9
                          }

                          
                          let font = UIFont(name: "Arial", size: CGFloat(fontSize))
                          cell.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
                        
                          // alter height and allow for multiple lines
                          cell.height = {70}
                          cell.segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
                          UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
                    
                      }
                
                // add legend below options
                if type.lowercased().contains("legend"){
                    for (index, option) in options.enumerated() {

                        form.last! <<< TextRow(){ row in
                            row.title = "\(index+1) - \(option)"
                        }.cellUpdate { cell, row in
                            let aa = UIFont(name: "Arial", size: CGFloat(12))
                            cell.textLabel?.font = aa
                            cell.height = {35}
                            cell.textLabel?.sizeToFit()
                            cell.separatorInset = UIEdgeInsets(top: 0, left: 2000, bottom: 0, right: 0)
        
                        }
                    }
                }
                
                
            } 
                
            
            /*else if type.contains(s: "MT001"){
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

             }*/

        }
    }

    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection: Int) {

        if let view = view as? UITableViewHeaderFooterView {
            if UIViewController().traitCollection.userInterfaceStyle == .dark{
                view.textLabel?.textColor = .white
            }else{
                view.textLabel?.textColor = .black
            }

            if(view.textLabel?.text?.hasPrefix("*"))!{
                view.textLabel?.textColor = UIColor(hue: 0.4917, saturation: 0.86, brightness: 0.65, alpha: 1.0)
            }
        }
    }

    func displayRequiredAlert(qNumber:Int){
        let alert = UIAlertController(title: "Require an Answer to Question \(qNumber)", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    @objc func submitClicked(){
        let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to submit the survey?", preferredStyle: UIAlertController.Style.alert)

        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
              print("Submission Confirmed")
              self.submitForm()
        }))

        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("User cancelled submission")
        }))

        present(confirmAlert, animated: true, completion: nil)
    }

    func submitForm(){

        var surveyResponses:[SurveyResponseStruct] = []
        var answeredQuestions = [Bool](repeating: false, count: form.allSections.count)
        for i in 0..<form.allSections.count{
            print("row number \(i).....\(String(describing: form.allSections[i].tag))")
            var response = ""
            var responseType = "value"
            var comment = ""
            var objectUrl = ""
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
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }
                    }else if taskType == "textarea"{
                        let row:TextAreaRow = form.rowBy(tag: "\(sectionTag)_row")!
                        if let temp = row.value{
                            response = temp.trim()
                        }
                        if (response.length == 0 && taskList[taskIndex].isRequired == 1){
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }
                    }else if taskType == "date"{
                        let row:DateRow = form.rowBy(tag: "\(sectionTag)_row")!
                        response = Utils.stringFromDate(date: row.value)
                        if (response.length == 0 && taskList[taskIndex].isRequired == 1){
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }

                    }else if taskType == "selection"{
                        let section  = form.sectionBy(tag: sectionTag) as! SelectableSection<ImageCheckRow<String>>
                        //print("select value:\(section?.selectedRows().map({$0.value!}))")
                        let answers:[String] = section.selectedRows().map({$0.value!})
                        for j in 0..<answers.count{
                            print("response from submission \(answers[j])")
                            response = response.appending("\(answers[j])")
                        }
                        if taskList[taskIndex].hasComment == 1 {
                            let row:TextAreaRow = form.rowBy(tag: "\(sectionTag)_comment")!
                            if let temp = row.value{
                                comment = temp.trim()
                                print("additioanl comment: \(comment)")
                            }
                        }

                        if response.hasSuffix("_"){
                            response = String(response.dropLast())
                        }

                        if (taskList[taskIndex].isRequired == 1 && (response.length == 0 && comment.length==0)){
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }

                    }else if taskType == "choice"{
                        let section  = form.sectionBy(tag: sectionTag) as! SelectableSection<ImageMultipleCheckRow<String>>
                        //print("select value:\(section?.selectedRows().map({$0.value!}))")
                        let answers:[String] = section.selectedRows().map({$0.value!})
                        for j in 0..<answers.count{
                            response = response.appending("\(answers[j])")
                        }
                        if taskList[taskIndex].hasComment == 1{
                            let row:TextAreaRow = form.rowBy(tag: "\(sectionTag)_comment")!
                            if let temp = row.value{
                                comment = temp.trim()
                                print("additioanl comment: \(comment)")
                            }
                        }
                        if response.hasSuffix("_"){
                            response = String(response.dropLast())
                        }
                        if (taskList[taskIndex].isRequired == 1 && (response.length == 0 && comment.length==0)){
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }
                    }else if taskType == "recording"{
                        responseType = "object"
                        let objectKey = "\(sectionTag)_row"
                        objectUrl = fileResponseDict[objectKey] ?? ""
                        if (taskList[taskIndex].isRequired == 1 && objectUrl.length == 0){
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }

                    }else if taskType == "rating"{
                        let row:PickerInlineRow<String> = form.rowBy(tag: "\(sectionTag)_row") as! PickerInlineRow<String>
                        response = row.value ?? "nil"
                        
                        if (response == "nil" && taskList[taskIndex].isRequired == 1){
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }

                    }else if taskType == "numeric"{
                        let row:IntRow = form.rowBy(tag: "\(sectionTag)_row") as! IntRow
                        let val = row.value ?? nil
                        
                       
                       if (val == nil && taskList[taskIndex].isRequired == 1){
                           displayRequiredAlert(qNumber: (i+1))
                           return
                       }
                       else{
                           response = String(describing: val)
                       }
                    }else if taskType.contains("likert"){
                        let row:SegmentedRow<String> = form.rowBy(tag: "\(sectionTag)_row") as! SegmentedRow<String>
                        
                        var response = row.value ?? "nil"

                        
                        if response.hasSuffix("_"){
                            response = String(response.dropLast())
                        }
                        
                        if (response == "nil" && taskList[taskIndex].isRequired == 1){
                            displayRequiredAlert(qNumber: (i+1))
                            return
                        }
                    }
                }
                surveyResponses.append(SurveyResponseStruct(studyId: self.studyId, surveyId: self.surveyId, taskId: self.taskList[taskIndex].taskId, version: self.version, submissionTime: String(Utils.currentUnixTime()), submissionTimeZone: "", answerType: responseType, answer: response, comment: comment, objectUrl: objectUrl))

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
            newResponse.comment = surveyResponses[i].comment
            newResponse.objectUrl = surveyResponses[i].objectUrl
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        if context.hasChanges {
            do{
                try context.save()
            }catch{
                print("error while saving context")
            }
        }
        printAllResponses(responses: getAllResponses())
        print("total rows: \(getAllResponses().count)")
        Syncer.sharedInstance.uploadSurveyResponses()

        //reno - save current time as last survey response time
        UserDefaults.standard.set(Date(), forKey: String(surveyId))


        // if event survey or follow-up update last3responses queue
        if(surveyId==23 || surveyId == 22){

            // check if null or not
            if var last3responses = UserDefaults.standard.array(forKey: String(surveyId) + "-last3responses") {

                // last 3 responses is full (reached queueLimit), remove oldest and add newest
                if (last3responses.count == queueLimit){
                    print("reached limit")

                    // remove oldest response, add newest
                    last3responses.removeLast()
                    last3responses.insert(Date(), at: 0)

                    UserDefaults.standard.set(last3responses, forKey: String(surveyId) + "-last3responses")
                }

                // last3responses has room for another date so add to it
                else{
                    print("room open")
                    last3responses.insert(Date(), at: 0)
                    UserDefaults.standard.set(last3responses, forKey: String(surveyId) + "-last3responses")
                }
            }

            // last3responses is null, so create queue with current date and time
            else{
                print("was null")
                let last3responses = [Date()]
                UserDefaults.standard.set(last3responses, forKey: String(surveyId) + "-last3responses")
            }

        }


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
            print("study id:\(response.studyId), survey id:\(response.surveyId), task id:\(response.taskId), version:\(response.version), submission time:\(response.submissionTime), time zone:\(response.submissionTimeZone), answer type:\(response.answerType), answer:\(response.answer), comment:\(response.comment), objectUrl:\(response.objectUrl)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func childViewControllerResponse(refernceAnswer: String) {
        print("reference answer: \(refernceAnswer)")
    }

    func passRecordingURL(objectKey: String, objectUrl: String) {
        print("receive key and value from delegate, \(objectKey), \(objectUrl)")
        fileResponseDict[objectKey] = objectUrl
    }
    
    func passPhotoURL(objectKey: String, objectUrl: String){
        print("receive key and value from delegate, \(objectKey), \(objectUrl)")
        filePhotoResponseDict[objectKey] = objectUrl
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
