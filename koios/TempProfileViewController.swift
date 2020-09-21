//
//  TempProfileViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/17/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Eureka

class TempProfileViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateProfile))
        
        //self.navigationItem.title = "Profile"
        
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
            <<< DateRow(){row in
                row.title = "Birth Date"
                //row.value = Date(timeIntervalSinceNow: 0)
                if let birthDate = Utils.getDataFromUserDefaults(key: "birthdate") as! String?{
                    row.value = Date(timeIntervalSince1970: TimeInterval(birthDate)!)
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

    }
    
    
    /*override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }*/

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateProfile(_ sender: Any) {
        print("profile updated...")
        //self.navigationController?.popViewController(animated: true)
        for i in 0..<form.allRows.count{
            if let title = form.allRows[i].title{
                print("title \(title)")
                if title.lowercased().hasPrefix("first"){
                    let firstNameRow = form.rows[i] as! TextRow
                    let firstName = firstNameRow.value ?? ""
                    Utils.saveDataToUserDefaults(data: firstName, key: "firstname")
                }else if title.lowercased().hasPrefix("last"){
                    let lastNameRow = form.rows[i] as! TextRow
                    let lastName = lastNameRow.value ?? ""
                    Utils.saveDataToUserDefaults(data: lastName, key: "lastname")
                }else if title.lowercased().hasPrefix("birth"){
                    let birthDateRow = form.rows[i] as! DateRow
                    if let birthDate = birthDateRow.value{
                        let dateString = String(birthDate.timeIntervalSince1970)
                        Utils.saveDataToUserDefaults(data: dateString, key: "birthdate")
                    }
                }else if title.lowercased().hasPrefix("gender"){
                    let genderRow = form.rows[i] as! ActionSheetRow<String>
                    let gender = genderRow.value ?? ""
                    Utils.saveDataToUserDefaults(data: gender, key: "gender")
                }else if title.lowercased().hasPrefix("ethnic"){
                    let ethnicRow = form.rows[i] as! PushRow<String>
                    let ethnic = ethnicRow.value ?? ""
                    Utils.saveDataToUserDefaults(data: ethnic, key: "ethnicity")
                }else if title.lowercased().hasPrefix("language"){
                    let languageRow = form.rows[i] as! PushRow<String>
                    let language = languageRow.value ?? ""
                    Utils.saveDataToUserDefaults(data: language, key: "language")
                }else if title.lowercased().hasPrefix("education"){
                    let educationRow = form.rows[i] as! PushRow<String>
                    let education = educationRow.value ?? ""
                    Utils.saveDataToUserDefaults(data: education, key: "education")
                }else if title.lowercased().hasPrefix("organization"){
                    let organizationRow = form.rows[i] as! TextRow
                    let organization = organizationRow.value ?? ""
                    Utils.saveDataToUserDefaults(data: organization, key: "organization")
                }
            }
        }
        
        performSegue(withIdentifier: "loadhomesegue", sender: nil)

    }
    
    
}

