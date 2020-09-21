//
//  SettingsViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/16/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: "ProfileViewCell", bundle: nil), forCellReuseIdentifier: "profileviewcell")
        tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileviewcell", for: indexPath) as! ProfileViewCell

        // Configure the cell...
        let email:String = Utils.getDataFromUserDefaults(key: "email") as! String

        cell.profileLabel.text = email

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("some cell selected...\(indexPath.section), \(indexPath.row)")
        if indexPath.section == 0{
            if let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "profileviewvc") as? ProfileViewController {                
                if let navigator = navigationController {
                    print("program comes did row select")
                    navigator.pushViewController(viewController, animated: true)
                }
            }

        }
    }
    

}
