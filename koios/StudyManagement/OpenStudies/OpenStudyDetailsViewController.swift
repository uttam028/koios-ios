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

class OpenStudyDetailsViewController: UITableViewController {

    var indexPathInList:IndexPath!
    var studyDetails:StudyStruct!
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enroll", style: .plain, target: self, action: #selector(enrollToStudy))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func enrollToStudy(){
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
            return 3
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Description"
        }else if section == 2{
            return "Instructions"
        }else if section == 3{
            return "Reviews"
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
            
            // Configure the cell...
            print("section \(indexPath.section), row:\(indexPath.row)")
            cell.descriptionLabel.text = "Review of participant \(indexPath.row)"
            return cell

        }

    }

}
