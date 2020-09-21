//
//  MotorTaskViewController.swift
//  tabletest
//
//  Created by Afzal Hossain on 3/3/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Eureka

class MotorTaskViewController: UIViewController, TypedRowControllerType {
    
    var delegate: ChildTaskViewControllerDelegate?
    var indexInParent:Int = -1
    /// The row that pushed or presented this controller
    //public var row: RowOf<UIImageView>!
    public var row: RowOf<MotorTask>!
    
    /// A closure to be called when the controller disappears.
    public var onDismissCallback: ((UIViewController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

