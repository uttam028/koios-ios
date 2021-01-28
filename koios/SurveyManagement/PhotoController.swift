//
// PhotoContoller.swift
//
//  Created by Reno Domel on 9/11/20.
//  Copyright © 2020 Reno Domel. All rights reserved.
//

import UIKit
import AVFoundation
import Eureka
import CoreData
import Alamofire
import SwiftyJSON

protocol SurveyObjectPhotoVCDelegate {
    func passPhotoURL(objectKey: String, objectUrl: String)
}


class PhotoContoller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var photoButton: UIButton!
    var uploadBarButton: UIBarButtonItem!
    var photoInstructions: UILabel!
    var myImageView: UIImageView!
    var exampleImageView: UIImageView!
    var w: CGFloat!
    var h: CGFloat!
    var studyId:Int32
    var surveyId:Int32
    var taskId:Int16
    var version:Int16
    var objectKey:String
    var objectUrl:String = ""
    var delegate: SurveyObjectPhotoVCDelegate! = nil
    
    
    
    
    init(studyId:Int32, surveyId:Int32, taskId:Int16, version:Int16, objectKey:String) {
        self.studyId = studyId
        self.surveyId = surveyId
        self.taskId = taskId
        self.version = version
        self.objectKey = objectKey
        
        

        
        
        super.init(nibName: nil, bundle: nil)
        uploadBarButton = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadTapped(_:)))
        self.navigationItem.rightBarButtonItem = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        w = UIScreen.main.bounds.size.width
        h = UIScreen.main.bounds.size.height
        
        photoButton = UIButton(type: .system)
        photoButton.setTitle("Import Photo", for: .normal)
        photoButton.frame = CGRect(x: w/3, y: 3*h/4, width: 100, height: 60)
        photoButton.center = CGPoint(x: w/2, y: 6*h/7)
        self.view.addSubview(photoButton)
        photoButton.addTarget(self, action: #selector(importTapped), for: .touchUpInside)
        
        photoInstructions = UILabel()
        photoInstructions.text = "Press import to import a photo from your camera roll"
        photoInstructions.lineBreakMode = .byWordWrapping
        photoInstructions.numberOfLines = 0
        photoInstructions.font = UIFont(name: "Arial", size: 18)
        photoInstructions.frame = CGRect(x: w/2, y: 5/9 * h, width: 300, height: 100)
        photoInstructions.center = CGPoint(x: w/2, y: 1/6 * h)
        photoInstructions.textAlignment = .center
        self.view.addSubview(photoInstructions)
        
        
        
        
        exampleImageView = UIImageView()
        exampleImageView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        exampleImageView.center = CGPoint(x: w/2, y: h/2 + 5)
        exampleImageView.image = UIImage(named: "genericPhoto")!
        self.view.addSubview(exampleImageView)
        
        
        myImageView = UIImageView()
        self.view.addSubview(myImageView)
        
        self.view.backgroundColor = UIColor.white
        
        
       
        
    }
    
    @objc func importTapped(_ sender: UIButton){
        let imageToImport = UIImagePickerController()
        imageToImport.delegate = self
        imageToImport.self
        imageToImport.sourceType = UIImagePickerController.SourceType.photoLibrary
        imageToImport.allowsEditing = false
        
        self.present(imageToImport, animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            exampleImageView.isHidden = true
            
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            if imageHeight > imageWidth {
                let newFrameHeight = 400
                let newFrameWidth = imageWidth / (imageHeight / CGFloat(newFrameHeight))
                myImageView.frame = CGRect(x: 0, y: 0, width: Int(newFrameWidth), height: newFrameHeight)
                myImageView.center = CGPoint(x: w/2, y: h/2)
                
            }
            else{
                let newFrameWidth = 350
                let newFrameHeight = imageHeight / (imageWidth / CGFloat(newFrameWidth))
                myImageView.frame = CGRect(x: 0, y: 0, width: newFrameWidth, height: Int(newFrameHeight))
                myImageView.center = CGPoint(x: w/2, y: h/2)
            }
            myImageView.image = image
            photoInstructions.text = "Press upload in the upper-right corner to upload the photo."
            self.navigationItem.rightBarButtonItem = uploadBarButton
            
        } else{
            print("Error in image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadTapped(_ sender: UIButton){
        let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to upload the photo?", preferredStyle: UIAlertController.Style.alert)

                      confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                            print("Submission Confirmed")
                            self.uploadPhoto()
                      }))

                      confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                            print("User cancelled submission")
                      }))

                      present(confirmAlert, animated: true, completion: nil)
        
    }
    
    func uploadPhoto(){
        print("Called upload photo")
        /*
         -ACTUAL UPLOADING TO SERVER HERE
         -CALL DELEGATE FUNCTION
         */
    }
    
}
