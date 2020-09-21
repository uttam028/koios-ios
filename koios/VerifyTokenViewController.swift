//
//  VerifyTokenViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 2/14/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VerifyTokenViewController: UIViewController {

    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.text = ""
        
        backButton.layer.borderColor = UIColor(red: 0.051, green: 0.1216, blue: 0.2118, alpha: 1.0).cgColor /* #0d1f36 */
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 2
        backButton.isHidden = true

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "welcomebackground")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        
        let border = CALayer()
        
        let width = CGFloat(2.0)
        
        border.borderColor = UIColor.lightGray.cgColor
        
        border.frame = CGRect(x: 0, y: tokenTextField.frame.size.height - width, width:  tokenTextField.frame.size.width, height: tokenTextField.frame.size.height)
        
        
        
        border.borderWidth = width
        
        tokenTextField.layer.addSublayer(border)
        
        tokenTextField.layer.masksToBounds = true
        
    }
    
    /*override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }*/


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tokenTextFieldChanged(_ sender: UITextField) {
        print("length of text field : \(String(describing: tokenTextField.text?.length))")
        errorLabel.text = ""
        let len = tokenTextField.text!.count
        let text:String = tokenTextField.text as String? ?? ""
        if len == 0{
            verifyButton.setTitle("Resend", for: .normal)
        } else if len < 4{
            verifyButton.setTitle("Verify", for: .normal)
            verifyButton.isEnabled = false
        } else if len == 4{
            verifyButton.isEnabled = true
            verifyButton.setTitle("Verify", for: .highlighted)
        } else{
            tokenTextField.text = String(describing: text.prefix(4))
        }
    }
    @IBAction func backToSignup(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyToken(_ sender: UIButton) {
        let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
        
        if self.verifyButton.currentTitle?.lowercased() == "resend" {
            let serviceUrl = Utils.getBaseUrl() + "signup/register?email=\(email)&uuid=\(Utils.getDeviceIdentifier())"
            Alamofire.request(serviceUrl).validate().responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value as Any)
                    let responseStruct = Response.responseFromJSONData(jsonData: json)
                    if responseStruct.code == 0{
                        //do nothing
                    } else{
                        // TODO: show error label
                    }
                case .failure(let error):
                    print(error)
                    // TODO: show error label
                }
            }

        } else if self.verifyButton.currentTitle?.lowercased() == "verify"{
            let token:String = self.tokenTextField.text as String? ?? ""
            let serviceUrl = Utils.getBaseUrl() + "signup/verify?email=\(email)&uuid=\(Utils.getDeviceIdentifier())&token=\(token)"
            Alamofire.request(serviceUrl).validate().responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value as Any)
                    let responseStruct = Response.responseFromJSONData(jsonData: json)
                    print("response after object : \(responseStruct.code), \(responseStruct.message)")
                    if responseStruct.code == 0{
                        Utils.saveDataToUserDefaults(data: true, key: "signedup")
                        Utils.generateSystemNotification(message: "Welcome to Koios. Join different studies to participate.")
                        
                        
                        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tempprofilevc") as! UINavigationController
                        self.present(nextViewController, animated: true, completion: nil)
                    } else{
                        // TODO: show error label- token mismatch
                        self.errorLabel.text = "Invalid Token"
                        self.backButton.isHidden = false
                    }
                case .failure(let error):
                    print(error)
                    // TODO: show error label - service not available
                }
            }
        }

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
