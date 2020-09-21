//
//  LabelHeaderReusableView.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/9/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit

class LabelHeaderReusableView: UICollectionReusableView, CollectionItemSelectDelegate {
        
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var stopWatch:MZTimerLabel?
    
    var isRunning = false
    var currentLabel:String = ""
    

    override func awakeFromNib() {
        stopButton.setTitle("Stop", for: .normal)
        stopButton.layer.borderColor = UIColor.black.cgColor
        stopButton.layer.borderWidth = 3
        stopButton.layer.cornerRadius = 15
        stopButton.addTarget(self, action: #selector(stopLabel), for: .touchUpInside)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.isHidden = true
        
        
        stopWatch = MZTimerLabel.init(label: timerLabel)
        timerLabel.text = ""
        timerLabel.isHidden = true
        

    }
    
    
    @objc func startLabel(label:String){
        
        if !currentLabel.isEmpty {
            Utils.uploadLabelData(labelTime: String(Utils.currentUnixTimeUptoSec()), label: currentLabel, labelType: "end")
        }
        timerLabel.isHidden = false
        stopWatch?.isHidden = false
        stopButton.isHidden = false
        //stopButton.titleLabel?.text = "Tap here to STOP"
        stopWatch?.reset()
        stopWatch?.start()
        isRunning = true
        currentLabel = label
        instructionLabel.text = label
        Utils.uploadLabelData(labelTime: String(Utils.currentUnixTimeUptoSec()), label: label, labelType: "start")
    }
    
    @objc func stopLabel(){
        Utils.uploadLabelData(labelTime: String(Utils.currentUnixTimeUptoSec()), label: currentLabel, labelType: "end")
        stopWatch?.reset()
        timerLabel.isHidden = true
        stopButton.isHidden = true
        //stopButton.titleLabel?.text = "Tap to START"
        isRunning = false
        currentLabel = ""
        instructionLabel.text = "Tap to Start"
    }
    
    func handleItemTapAction(label: String) {
        if label.lowercased() == currentLabel.lowercased() && isRunning{
            DispatchQueue.main.async {
                self.stopLabel()
            }
        }else{
            DispatchQueue.main.async {
                self.startLabel(label: label)
            }
        }

    }
    
}
