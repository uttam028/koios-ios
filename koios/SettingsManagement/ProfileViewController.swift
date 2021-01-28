//
//  ProfileViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/16/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Eureka
import SwiftyJSON
import Alamofire

class ProfileViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateProfile))
        
        self.navigationItem.title = "Profile"
        
        form +++ Section()
            <<< TextRow(){ row in
                row.title = "Email"
                let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
                row.value = email
                //row.placeholder = email
                row.disabled = true
        }
        
        form +++ Section()
            <<< TextRow(){row in
                row.title = "First Name"
                if let firstname = Utils.getDataFromUserDefaults(key: "firstname") as! String?{
                    print("should get first name")
                    if firstname.isEmpty{
                        row.placeholder = "Enter Text Here"
                    }else{
                        row.value = firstname
                    }
                    
                }else{
                    print("strange")
                    row.placeholder = "Enter Text Here"
                }
                
            }
            <<< TextRow(){row in
                row.title = "Last Name"
                if let lastname = Utils.getDataFromUserDefaults(key: "lastname") as! String?{
                    if lastname.isEmpty{
                        row.placeholder = "Enter Text Here"
                    }else{
                        row.value = lastname
                    }
                    
                }else{
                    row.placeholder = "Enter Text Here"
                }
                
        }
        
        form +++ Section()
            <<< TextRow(){row in
                row.title = "Device Model Number"
                
                if let deviceModelNumber = Utils.getDataFromUserDefaults(key: "device_model_number") as! String?{
                    if deviceModelNumber.isEmpty{
                        row.placeholder = "Enter Text Here"
                    }else{
                        row.value = deviceModelNumber
                    }
                }else{
                    row.placeholder = "Enter Text Here"
                }
        }
        
        
        form +++ Section()
            <<< DateRow(){row in
                row.title = "Birth Date"
                //row.value = Date(timeIntervalSinceNow: 0)
                if let birthDate = Utils.getDataFromUserDefaults(key: "birthdate") as! String?{
                    //row.value = Date(timeIntervalSince1970: TimeInterval(birthDate)!)
                    row.value = Utils.dateFromString(str: birthDate)
                }
            }
            <<< ActionSheetRow<String>(){row in
                row.title = "Gender"
                row.selectorTitle = "Specify Your Gender"
                row.options = ["Male", "Female", "Other", "I do not like to share"]
                //row.onChange({_ in
                //print("value has been changed...")
                //self.navigationItem.rightBarButtonItem?.isEnabled = true
                //})
                if let gender = Utils.getDataFromUserDefaults(key: "gender") as! String?{
                    if !gender.isEmpty{
                        if row.options!.contains(gender){
                            row.value = gender
                        }
                    }
                }
            }
            <<< PushRow<String>(){row in
                row.title = "Ethnicity"
                row.selectorTitle = "Select Your Ethnicity"
                row.options = ["Caucasian", "Latino/Hispanic", "African", "Middle Eastern", "South Asian", "East Asian", "Mixed", "Other"]
                if let ethnicity = Utils.getDataFromUserDefaults(key: "ethnicity") as! String?{
                    if !ethnicity.isEmpty{
                        if row.options!.contains(ethnicity){
                            row.value = ethnicity
                        }
                    }
                }
        }
        
        
        form +++ Section()
            <<< PushRow<String>(){row in
                row.title = "Language"
                row.selectorTitle = "Select Your Native Language"
                row.options = ["English", "Spanish", "Chinese", "French", "Italian", "German", "Japanese", "Russian", "Hindi", "Arabic", "Other"]
                if let language = Utils.getDataFromUserDefaults(key: "language") as! String?{
                    if !language.isEmpty{
                        if row.options!.contains(language){
                            row.value = language
                        }
                    }
                }
            }
            <<< PushRow<String>(){row in
                row.title = "Education"
                row.selectorTitle = "Select Highest Level"
                row.options = ["High School", "Some College", "Bachelor's Degree", "Graduate School", "Doctorate"]
                if let education = Utils.getDataFromUserDefaults(key: "education") as! String?{
                    if !education.isEmpty{
                        if row.options!.contains(education){
                            row.value = education
                        }
                    }
                }
            }
            <<< TextRow(){row in
                row.title = "Organization"
                
                if let organization = Utils.getDataFromUserDefaults(key: "organization") as! String?{
                    if organization.isEmpty{
                        row.placeholder = "Enter Text Here"
                    }else{
                        row.value = organization
                    }
                }else{
                    row.placeholder = "Enter Text Here"
                }
            }
        <<< LabelRow(){ row in
            row.title = "Version"
            row.value = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! Cell<String>.Value
        }
        form +++ Section()
            <<< TextRow(){ row in
                row.title = "Email"
                let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
                row.value = email
                //row.placeholder = email
                row.disabled = true
                
            }
        /*
        form +++ Section()
            <<< SwitchRow(){ row in
                row.title = "Pause participation in all studies"
                }.cellUpdate() {cell, row in
                cell.textLabel?.textColor = .red
            }
        */
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func updateProfile(){
        print("profile updated...")
        
        var profileDict = [String:String]()
        
        for i in 0..<form.allRows.count{
            if let title = form.allRows[i].title{
                print("title \(title)")
                if title.lowercased().hasPrefix("first"){
                    let firstNameRow = form.rows[i] as! TextRow
                    let firstName = firstNameRow.value ?? ""
                    let key:String = "firstname"
                    Utils.saveDataToUserDefaults(data: firstName, key: key)
                    profileDict[key] = firstName
                }else if title.lowercased().hasPrefix("last"){
                    let lastNameRow = form.rows[i] as! TextRow
                    let lastName = lastNameRow.value ?? ""
                    let key:String = "lastname"
                    Utils.saveDataToUserDefaults(data: lastName, key: key)
                    profileDict[key] = lastName
                }else if title.lowercased().hasPrefix("birth"){
                    let birthDateRow = form.rows[i] as! DateRow
                    if let birthDate = birthDateRow.value{
                        let dateString = Utils.stringFromDate(date: birthDate)
                        let key:String = "birthdate"
                        Utils.saveDataToUserDefaults(data: dateString, key: key)
                        profileDict[key] = dateString
                    }
                }else if title.lowercased().hasPrefix("gender"){
                    let genderRow = form.rows[i] as! ActionSheetRow<String>
                    let gender = genderRow.value ?? ""
                    let key:String = "gender"
                    Utils.saveDataToUserDefaults(data: gender, key: key)
                    profileDict[key] = gender
                }else if title.lowercased().hasPrefix("ethnic"){
                    let ethnicRow = form.rows[i] as! PushRow<String>
                    let ethnic = ethnicRow.value ?? ""
                    let key:String = "ethnicity"
                    Utils.saveDataToUserDefaults(data: ethnic, key: key)
                    profileDict[key] = ethnic
                }else if title.lowercased().hasPrefix("language"){
                    let languageRow = form.rows[i] as! PushRow<String>
                    let language = languageRow.value ?? ""
                    let key:String = "language"
                    Utils.saveDataToUserDefaults(data: language, key: key)
                    profileDict[key] = language
                }else if title.lowercased().hasPrefix("education"){
                    let educationRow = form.rows[i] as! PushRow<String>
                    let education = educationRow.value ?? ""
                    let key:String = "education"
                    Utils.saveDataToUserDefaults(data: education, key: key)
                    profileDict[key] = education
                }else if title.lowercased().hasPrefix("organization"){
                    let organizationRow = form.rows[i] as! TextRow
                    let organization = organizationRow.value ?? ""
                    let key:String = "organization"
                    Utils.saveDataToUserDefaults(data: organization, key: key)
                    profileDict[key] = organization
                }else if title.lowercased().hasPrefix("device"){
                    let deviceNumRow = form.rows[i] as! TextRow
                    let deviceNum = deviceNumRow.value ?? ""
                    let key:String = "device_model_number"
                    Utils.saveDataToUserDefaults(data: deviceNum, key: key)
                    profileDict[key] = deviceNum
                }
                else if title.lowercased().hasPrefix("version"){
                    let versionRow = form.rows[i] as! LabelRow
                    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
                }
            }
        }

        let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
        let parameters = profileDict
        let serviceUrl = Utils.getBaseUrl() + "signup/profile?email=\(email)&uuid=\(Utils.getDeviceIdentifier())"
        
        Alamofire.request(serviceUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value as Any)
                let responseStruct = Response.responseFromJSONData(jsonData: json)
                print("response code \(responseStruct.code)")
            case .failure(let error):
                print(error)
            }
        }
        
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
