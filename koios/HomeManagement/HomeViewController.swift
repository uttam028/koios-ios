//
//  HomeViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/15/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    fileprivate let reuseIdentifier = "homeiconviewcell"
    fileprivate var contextViewController: ContextViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.register(HomeIconViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()

        //self.tableView.backgroundView = UIImageView(image: UIImage(named: "backgroundnologo"))
        
        contextViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "contextrootvc") as? ContextViewController
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.extendedLayoutIncludesOpaqueBars = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 3 {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((self.tableView.bounds.height - (self.navigationController?.navigationBar.frame.height)! - (self.tabBarController?.tabBar.frame.height)!) - 120) / 3
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HomeIconViewCell//

        // Configure the cell...
        if indexPath.section == 0 {
            //cell.iconLabel.text = "Label"
            let iconImage = UIImage(named: "label") as UIImage?
            //cell.selectionImageView.image = iconImage
            cell.iconImageView.image = iconImage

        }else if indexPath.section == 1{
            //cell.iconLabel.text = "Survey"
            let iconImage = UIImage(named: "survey") as UIImage?
            //cell.selectionImageView.image = iconImage
            cell.iconImageView.image = iconImage
        }else if indexPath.section == 2{
            //cell.iconLabel.text = "Task"
            let iconImage = UIImage(named: "tasks") as UIImage?
            //cell.selectionImageView.image = iconImage
            cell.iconImageView.image = iconImage
        }

        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            navigationController?.pushViewController(contextViewController, animated: true)
        }else if indexPath.section == 1{
            if let viewController = UIStoryboard(name: "Survey", bundle: nil).instantiateViewController(withIdentifier: "activesurveysvc") as? ActiveSurveysViewController {
                
                if let navigator = navigationController {
                    print("program comes did row select")
                    //navigator.hidesBottomBarWhenPushed = true
                    navigator.pushViewController(viewController, animated: true)
                }
            }

        }
        else if indexPath.section == 2{
            if let viewController = UIStoryboard(name: "Task", bundle: nil).instantiateViewController(withIdentifier: "activetaskgroupvc") as? ActiveTasksGroupViewController {

                if let navigator = navigationController {
                    print("program comes did row select")
                    //navigator.hidesBottomBarWhenPushed = true
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
