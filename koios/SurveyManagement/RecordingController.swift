//
//  ViewController.swift
//  TestRecording3
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

protocol SurveyObjectVCDelegate {
    func passRecordingURL(objectKey: String, objectUrl: String)
}


class RecordingController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    
    var delegate: SurveyObjectVCDelegate! = nil
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var fileName = "recording.m4a"
    var audioFilename : URL!
    var recordedAlready = false;
    var playingRecording = false;
    var recording = false;
    
    var uploadBarButton: UIBarButtonItem!
    
    var playButton: UIButton!
//    var uploadButton: UIButton!
    var recordInstructions: UILabel!
    var uploadInstructions: UILabel!
    
    var studyId:Int32
    var surveyId:Int32
    var taskId:Int16
    var version:Int16
    var objectKey:String
    var objectUrl:String = ""
    
    
    
    
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
        
        
        recordButton = UIButton(type: .system)
        playButton = UIButton(type: .system)
//        uploadButton = UIButton(type: .system)
        
        recordInstructions = UILabel()
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        recordInstructions.frame = CGRect(x: w/2, y: 5/9 * h, width: 500, height: 20)
        recordInstructions.center = CGPoint(x: w/2, y: 5/9 * h)
        recordInstructions.textAlignment = .center
        
        uploadInstructions = UILabel()
        uploadInstructions.frame = CGRect(x: w/2, y: 2 * h/9, width: 500, height: 20)
        uploadInstructions.center = CGPoint(x: w/2, y: 2 * h/9)
        uploadInstructions.textAlignment = .center
        
        recordButton.frame = CGRect(x: w / 4.2, y: h/3, width: 60, height: 60)
        playButton.frame = CGRect(x: 2.6 * w / 4, y: h/3, width: 60, height: 60)
        
        
        self.view.addSubview(recordInstructions)
        self.view.addSubview(uploadInstructions)
        
        
        
//        uploadButton.titleLabel?.font = UIFont(name: "font", size: 400)
//        uploadButton.setTitle("Upload", for: .normal)
        
        
        self.view.backgroundColor = UIColor.white
        
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                        self.playRecordingUI()
                        self.uploadButtonUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    
    
    func uploadButtonUI(){
//        self.view.addSubview(uploadButton)
//        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
    }
    
    func playRecordingUI(){
        self.view.addSubview(playButton)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    func loadRecordingUI() {
        self.view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        recordInstructions.text = "Click on the microphone to begin recording"
        recordButton.setImage(UIImage(named: "mic"), for: .normal)
    }
    
    func startRecording(_ sender: UIButton) {
        self.navigationItem.rightBarButtonItem = nil
        uploadInstructions.isHidden = true
        if !recordedAlready
        {
            audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
            recordedAlready = true
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        if !playingRecording{
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                recording = true
                recordInstructions.text = "Click the stop button to stop recording"
                recordButton.setImage(UIImage(named: "stop"), for: .normal)
            } catch {
                finishRecording()
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        recording = false
        recordInstructions.text = "Click on the microphone to re-record"
        uploadInstructions.text = "Click upload to submit the file"
        uploadInstructions.isHidden = false
        self.navigationItem.rightBarButtonItem = uploadBarButton
        recordButton.setImage(UIImage(named: "mic"), for: .normal)
        
    }
    
    func finishedPlaying(){
        audioPlayer.stop()
        playingRecording = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    @objc func recordTapped( sender: UIButton) {
        if audioRecorder == nil {
            startRecording(sender)
        } else {
            finishRecording()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playingRecording = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    @objc func playTapped(_ sender: UIButton) {
        if recordedAlready && !recording{
            if !playingRecording{
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
                    audioPlayer.delegate = self
                    audioPlayer.volume = 1.0
                    playingRecording = true
                    playButton.setImage(UIImage(named: "pause"), for: .normal)
                    
                    audioPlayer.play()
                }
                catch{
                }
            } else{
                audioPlayer.stop()
                playingRecording = false
                playButton.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }
    
    
    @objc func uploadTapped(_ sender: UIButton){
        let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to upload the recording?", preferredStyle: UIAlertController.Style.alert)

               confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                     print("Submission Confirmed")
                     self.uploadRecording()
               }))

               confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                     print("User cancelled submission")
               }))

               present(confirmAlert, animated: true, completion: nil)
    }
    
    func uploadRecording(){
        // upload file
        print("Called upload recording")
        if !recording && !playingRecording && recordedAlready{
            
            let parameters = ["contentType":"multipart/form-data"]
            let headers: HTTPHeaders = ["secret": "k0i0sgener!cByAfzalFromNDmL@b"]
            let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
            let serviceUrl = Utils.getBaseUrl() + "files/upload_study_object?email=\(email)&uuid=\(Utils.getDeviceIdentifier())&studyId=\(self.studyId)"
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    print("file to uplpoad \(self.audioFilename.absoluteString)")
                    multipartFormData.append(self.audioFilename, withName: "file")
                    for (key, val) in parameters {
                        multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                    }
            },
                to: serviceUrl,
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            let json = JSON(response.result.value as Any)
                            let responseStruct = Response.responseFromJSONData(jsonData: json)
                            if responseStruct.code == 0{
                                var deleteStatus = FCFileManager.removeItem(atPath: self.audioFilename.absoluteString)
                                print("file deletion from local:\(deleteStatus)")
                                self.navigationController?.popViewController(animated: true)
                                self.delegate.passRecordingURL(objectKey: self.objectKey, objectUrl: responseStruct.message)
                            }else{
                                //not able to save the file, handle on the UI
                            }
                        }
                    case .failure(let encodingError):
                        print("upload error \(encodingError)")
                    }
            }
            )
            
        }
        
        return;
    }
    
}
