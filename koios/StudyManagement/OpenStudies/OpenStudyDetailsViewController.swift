//
//  OpenStudyDetailsViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/7/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ResearchKit

class OpenStudyDetailsViewController: UITableViewController {

    var indexPathInList:IndexPath!
    var studyDetails:StudyStruct!
    var EnrollKey:String!
    var sectionList:[ConsentSectionStruct] = [ConsentSectionStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UINib(nibName: "OpenStudyBannerViewCell", bundle: nil), forCellReuseIdentifier: "openstudybannercell")
        self.tableView.register(OpenStudyDescriptionViewCell.self, forCellReuseIdentifier: "openstudydescriptioncell")
        self.tableView.register(OpenStudyInstructionViewCell.self, forCellReuseIdentifier: "openstudyinstructionncell")
        
        self.tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()

        EnrollKey = "enroll" + String(self.studyDetails.studyId)
        
        // reno - check if user has enrolled and create enroll/unenroll button
        if let dateJoined = UserDefaults.standard.object(forKey: EnrollKey) {
            
            // UNCOMMENT THIS LINE WHEN THE BACKEND FOR UNENROLLMENT IS FINISHED
            //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave Study", style: .plain, target: self, action: #selector(leaveTapped))
            
            print("Not enrolled")
            
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enroll", style: .plain, target: self, action: #selector(enrollTapped))
            print("Enrolled")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func leaveTapped(){
           let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to leave this study?", preferredStyle: UIAlertController.Style.alert)

           confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                 print("Unenrollment Confirmed")
                 self.unenrollToStudy()
           }))

           confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                 print("User cancelled unenrollment")
           }))

           present(confirmAlert, animated: true, completion: nil)
       }
    
    func unenrollToStudy(){
        print("Beginning unenrollment in study")
        
        // implementation needs to be completed
    }
    
    @objc func enrollTapped(){
        
        let studyId = self.studyDetails.studyId
        var serviceUrl = Utils.getBaseUrl() + "consent/required?study_id=\(studyId)"
        Alamofire.request(serviceUrl, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value as Any)
                let responseStruct = Response.responseFromJSONData(jsonData: json)
                print("response after object : \(responseStruct.code), \(responseStruct.message), \(serviceUrl)")
                if responseStruct.code == 1{
                    // 1 - required
                    serviceUrl = Utils.getBaseUrl() + "consent/template?study_id=\(studyId)"
                    Alamofire.request(serviceUrl, headers: headers).validate().responseJSON { response in
                        switch response.result {
                        case .success:
                            let sectionJson = JSON(response.result.value as Any)
                            print("response after object : \(sectionJson), \(serviceUrl)")
                            self.sectionList = [ConsentSectionStruct]()
                            for item in sectionJson.arrayValue{
                                self.sectionList.append(ConsentSectionStruct.responseFromJSONData(jsonData: item))
                            }
                            DispatchQueue.main.async {
                                let viewController = self.getConsentController(sectionList: self.sectionList)
                                self.present(viewController, animated: true, completion: nil)
                            }
                        case .failure(let error):
                            print("error in ping: \(error.localizedDescription)")
                        }
                    }
                    
                } else if responseStruct.code==0{
                    //0 - not required
                    DispatchQueue.main.async {
                        self.popupConfirmation()
                    }
                } else{
                    //-1 - error, should not proceed
                    DispatchQueue.main.async {
                        self.popupError()
                    }
                }
            case .failure(let error):
                print("error in ping: \(error.localizedDescription)")
            }
        }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }
    
    func popupError(){
        let confirmAlert = UIAlertController(title: "Error", message: "Service is not available, please try later.", preferredStyle: UIAlertController.Style.alert)

        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Error occured")
        }))
        present(confirmAlert, animated: true, completion: nil)
    }
    
    func popupConfirmation(){
        let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to enroll in this study?", preferredStyle: UIAlertController.Style.alert)

        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
              print("Enrollment Confirmed")
              self.enrollToStudy()
        }))

        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("User cancelled enrollment")
        }))

        present(confirmAlert, animated: true, completion: nil)
    }
    
    func enrollToStudy(){
        let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
        let serviceUrl = Utils.getBaseUrl() + "study/enroll?email=\(email)&uuid=\(Utils.getDeviceIdentifier())&id=\(self.studyDetails.studyId)&jointime=\(Date().timeIntervalSince1970)&jointimezone=\(240)"
        Alamofire.request(serviceUrl).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value as Any)
                let responseStruct = Response.responseFromJSONData(jsonData: json)
                print("response after enrollment : \(responseStruct.code), \(responseStruct.message)")
                if responseStruct.code == 0{
                    Syncer.sharedInstance.insertStudy(studyStruct: self.studyDetails)
                    let userInfo = [ "index" : self.indexPathInList, "studyName" : self.studyDetails.name, "studyId" : self.studyDetails.studyId ] as [String : Any]
                    //reno - save current time as last survey response time
                    let EnrollDateKey = "enroll" + String(self.studyDetails.studyId)
                    UserDefaults.standard.set(Date(), forKey: String(EnrollDateKey))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enrolledtostudy"), object: nil, userInfo: userInfo)
                    self.navigationController?.popViewController(animated: true)
                } else{
                    // TODO: show error label- token mismatch
                    //self.errorLabel.text = "Invalid Token"
                }
            case .failure(let error):
                print(error)
                // TODO: show error label - service not available
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 || section == 1 || section == 2{
            return 1
        }else{
            return 1 // this should change if we add more additional inforamtion
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Description"
        }else if section == 2{
            return "Instructions"
        }else if section == 3{
            return "Additional Information"
        }else{
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
        }else{
            return UITableView.automaticDimension
        }
        
        //return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "openstudybannercell", for: indexPath) as! OpenStudyBannerViewCell
            
            // Configure the cell...
            print("section \(indexPath.section), row:\(indexPath.row)")
            //cell.descriptionLabel.text = "hfjk fsdfh dsjfhsdj  jfhdj sfsf fhdjk fsdjf dsjfh . fdskf sdf /fdf hdsfd fjfsk fdjks dfjskdfjsdf f dsjjf f kjf.ahs cncjhasdhibjhfiouur9wern38f fhsiudhishk dm djduhaiuhd mn hdas djansjkdk."
            cell.nameLabel.text = studyDetails.name
            
            cell.orgLabel.textColor = UIColor(red: 0.051, green: 0.1216, blue: 0.2118, alpha: 1.0) /* #0d1f36 */
            cell.orgLabel.text = Utils.defaultOrganization
            
            cell.studyImage.image = UIImage(named: "task")
            cell.studyImage.contentMode = .scaleAspectFit
            return cell

        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "openstudydescriptioncell", for: indexPath) as! OpenStudyDescriptionViewCell
            
            // Configure the cell...
            print("section \(indexPath.section), row:\(indexPath.row)")
            cell.descriptionLabel.text = studyDetails.studyDescription
            return cell

        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "openstudyinstructionncell", for: indexPath) as! OpenStudyInstructionViewCell
            
            // Configure the cell...
            print("section \(indexPath.section), row:\(indexPath.row)")
            cell.instructionLabel.text = studyDetails.instruction
            return cell
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "openstudydescriptioncell", for: indexPath) as! OpenStudyDescriptionViewCell
            
            if indexPath.row == 0{
                
                print("section \(indexPath.section), row:\(indexPath.row)")
                if let dateJoined = UserDefaults.standard.object(forKey: EnrollKey){
                    let df = DateFormatter()
                               df.dateFormat = "MM/dd/yyyy"
                    cell.descriptionLabel.text = "Enrollment Status: Enrolled on \(df.string(from: dateJoined as! Date))"
                
                }else{
                    cell.descriptionLabel.text = "Enrollment Status: Not Enrolled"
                }
                
            }
            
            return cell

        }

    }

}


extension OpenStudyDetailsViewController:ORKTaskViewControllerDelegate, UIPopoverPresentationControllerDelegate{
//    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
//        <#code#>
//    }
    
    private func getConsentController(sectionList:[ConsentSectionStruct])->ORKTaskViewController{
        let taskViewController = ORKTaskViewController(task: ConsentGenerator.getConsentTask(listOfSections: sectionList), taskRun: nil)
        
        taskViewController.delegate = self
        
        taskViewController.view.tintColor = UIColor(red: 0.8824, green: 0.7059, blue: 0.1647, alpha: 1.0) /* #gold */
        //taskViewController.view.tintColor = UIColor(red: 0.051, green: 0.1216, blue: 0.2118, alpha: 1.0)/* #blue */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.tintColor = UIColor(red: 0.051, green: 0.1216, blue: 0.2118, alpha: 1.0)/* #blue */
//        taskViewController.modalPresentationStyle = .popover
        taskViewController.modalPresentationStyle = .overFullScreen
        return taskViewController
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
        
        case .completed:
            print("result completed")
            let result = taskViewController.result
            if let stepResult = result.stepResult(forStepIdentifier: "ConsentReviewStep"), let signatureResult = stepResult.results?.first as? ORKConsentSignatureResult{
                
                
                if signatureResult.consented{
                    //                    Utils.saveDataToUserDefaults(data: signatureResult.signature?.givenName, key: "firstname")
                    //                    Utils.saveDataToUserDefaults(data: signatureResult.signature?.familyName, key: "lastname")
                    Utils.saveDataToUserDefaults(data: "consented", key: "userstate")
                    //                    let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tempprofilevc") as! UINavigationController
                    let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ApplicationStory")
                    
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //show window
                    appDelegate.window?.rootViewController = nextViewController
                    
                }else{
                    taskViewController.dismiss(animated: true, completion: nil)
                    //                    self.tableView.reloadData()
                }
                
                print("sign result \(String(describing: signatureResult.signature?.familyName)), \(String(describing: signatureResult.signature?.givenName)), title: \(signatureResult.signature?.title)")
                let document = ConsentGenerator.getConsentDocument(listOfSections: self.sectionList).copy() as! ORKConsentDocument
                 signatureResult.apply(to: document)
                 
                 
                document.makePDF { (pdfFile, error) -> Void in

                    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as URL?
                    docURL = docURL?.appendingPathComponent( "consent.pdf") as URL?
                    print("doc urL:\(String(describing: docURL))")

                    do{
                        //write your file to the disk.
                        try pdfFile?.write(to: docURL!)
                        //now you can see that pdf in your applications directory

                    }catch{
                        
                    }
                }
                
//                 consentDocument.makePDF { (data, error) -> Void in
//                    let tempPath = NSTemporaryDirectory() as NSString
//                    let path = tempPath.appendingPathComponent("signature.pdf")
//                    data?.write(to: URL(string: path)!, options: Data.WritingOptions.atomic)
//                    print("file path \(path)")
//                 }
//
            }
            
        default:
            print("cancel steps")
            taskViewController.dismiss(animated: true, completion: nil)
            //            self.tableView.reloadData()
        }
        
        print("did finish with \(reason.rawValue), \(taskViewController.result.stepResult(forStepIdentifier:"ConsentTask" ))")
        
    }

    
    
}
