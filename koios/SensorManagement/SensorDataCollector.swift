//
//  SensorDataCollector.swift
//  cimonv2
//
//  Created by Afzal Hossain on 1/22/19.
//  Copyright © 2019 Afzal Hossain. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion




public class SensorDataCollector:NSObject{
    
    
    static let sharedInstance = SensorDataCollector()

    //static string from sensor config plist
    fileprivate let AccelSensing = "accelSensing"
    fileprivate let AccelFrequency = "accelFrequency"
    fileprivate let GyroSensing = "gyroSensing"
    fileprivate let GyroFrequency = "gyroFrequency"
    fileprivate let MagnetSensing = "magnetSensing"
    fileprivate let MagnetFrequency = "magnetFrequency"
    fileprivate let DeviceMotionSensing = "devicemotionSensing"
    fileprivate let DeviceMotionFrequency = "devicemotionFrequency"
    fileprivate let AltimeterSensing = "altimeterSensing"
    
    fileprivate let BatteryStateEvent = "batteryStateEvent"
    fileprivate let BatteryLevelEvent = "batteryLevelEvent"
    fileprivate let ScreenEvent = "screenEvent"
    fileprivate let DisplayEvent = "displayEvent"

    
    
    
    //boolean to indicate if sensing is active
    var accelSensing:Bool?
    var gyroSensing:Bool?
    var magnetSensing:Bool?
    var devicemotionSensing:Bool?
    var altimeterSensing:Bool?
    
    var batteryStateEvent:Bool?
    var batteryLevelEvent:Bool?
    var screenEvent:Bool?
    var displayEvent:Bool?
    

    //frequency of sensing
    var accelFrequency:TimeInterval?
    var gyroFrequency:TimeInterval?
    var magnetFrequency:TimeInterval?
    var devicemotionFrequency:TimeInterval?

    
    //sensors and config
    var motionManager:CMMotionManager?
    var altimeter:CMAltimeter?
    var sensorConfigDictionary:NSMutableDictionary?
    static var isCoreSensingRunning:Bool = false

    
    
    
    
    override init(){
        super.init()
        print("Initializing.................")
        motionManager = CMMotionManager()
        altimeter = CMAltimeter()
        sensorConfigDictionary = Utils.loadPlistData(plistFileName: "sensorcoreconfig")
        SensorDataCollector.isCoreSensingRunning = false
    }
    
    func startCoreSensing(){
        
        //sensing state assignment
        accelSensing = Utils.getMappedValue(dict: sensorConfigDictionary, key: AccelSensing) as? Bool
        gyroSensing = Utils.getMappedValue(dict: sensorConfigDictionary, key: GyroSensing) as? Bool
        magnetSensing = Utils.getMappedValue(dict: sensorConfigDictionary, key: MagnetSensing) as? Bool
        devicemotionSensing = Utils.getMappedValue(dict: sensorConfigDictionary, key: DeviceMotionSensing) as? Bool
        altimeterSensing = Utils.getMappedValue(dict: sensorConfigDictionary, key: AltimeterSensing) as? Bool
        
        batteryStateEvent = Utils.getMappedValue(dict: sensorConfigDictionary, key: BatteryStateEvent) as? Bool
        batteryLevelEvent = Utils.getMappedValue(dict: sensorConfigDictionary, key: BatteryLevelEvent) as? Bool
        screenEvent = Utils.getMappedValue(dict: sensorConfigDictionary, key: ScreenEvent) as? Bool
        displayEvent = Utils.getMappedValue(dict: sensorConfigDictionary, key: DisplayEvent) as? Bool

        
        //sensing frequency assignment
        accelFrequency = Utils.getMappedValue(dict: sensorConfigDictionary, key: AccelFrequency) as? TimeInterval
        gyroFrequency = Utils.getMappedValue(dict: sensorConfigDictionary, key: GyroFrequency) as? TimeInterval
        magnetFrequency = Utils.getMappedValue(dict: sensorConfigDictionary, key: MagnetFrequency) as? TimeInterval
        devicemotionFrequency = Utils.getMappedValue(dict: sensorConfigDictionary, key: DeviceMotionFrequency) as? TimeInterval

        
        if accelFrequency == nil {
            accelFrequency = 0.0
        }
        if(gyroFrequency == nil){
            gyroFrequency = 0.0
        }
        if magnetFrequency == nil{
            magnetFrequency = 0.0
        }
        if devicemotionFrequency == nil{
            devicemotionFrequency = 0.0
        }

 
        
        if accelSensing != nil {
            if accelSensing!{
                startAccelarometer()
            }
        }
        
        if gyroSensing != nil{
            if gyroSensing!{
                startGyro()
            }
        }
        
        if magnetSensing != nil{
            if magnetSensing!{
                startMagnetometer()
            }
        }
        
        if devicemotionSensing != nil{
            if devicemotionSensing!{
                startDeviceMotionMonitor()
            }
        }
        
        if altimeterSensing != nil{
            if altimeterSensing!{
                startAltitudeMonitor()
            }
        }
        
        if batteryStateEvent != nil{
            if batteryStateEvent!{
                startMonitorBatteryState()
            }
        }

        if batteryLevelEvent != nil{
            if batteryLevelEvent!{
                startMonitorBatteryLevel()
            }
        }
    }
    
    
    private func startAccelarometer(){
        if(motionManager!.isAccelerometerAvailable){
            motionManager!.accelerometerUpdateInterval = (1.0/accelFrequency!)
            motionManager!.startAccelerometerUpdates(to: OperationQueue(), withHandler:
                {data,error in
                    //if let isError = error{
                    //println("error reading accel data :\(isError)")
                    //}
                    guard let data = data else{
                        return
                    }
                    //event,time,x,y,z
                    logw(text: "accel,\(Utils.currentUnixTime()),\(data.acceleration.x),\(data.acceleration.y),\(data.acceleration.z)")
            }
            )
            accelSensing = true
        }else{
            accelSensing = false
        }
    }
    
    private func stopAccelerometer(){
        if(motionManager!.isAccelerometerAvailable && motionManager!.isAccelerometerActive){
            motionManager!.stopAccelerometerUpdates()
        }
        accelSensing = false
    }
    
    private func startGyro(){
        print("start gyro")
        
        if(motionManager!.isGyroAvailable){
            print("Gyro is available")
            if(!motionManager!.isGyroActive){
                print("Gyro is active")
                motionManager!.gyroUpdateInterval = (1.0/gyroFrequency!)
                
                motionManager!.startGyroUpdates(to: OperationQueue(), withHandler:
                    {data, error in
                        guard let data = data else{
                            return
                        }
                        
                        //event,time,x,y,z
                        logw(text: "gyro,\(Utils.currentUnixTime()),\(data.rotationRate.x),\(data.rotationRate.y),\(data.rotationRate.z)")
                        
                })
                
            }
            gyroSensing = true
        }else{
            gyroSensing = false
        }
        
    }

    private func stopGyro(){
        if(self.motionManager!.isGyroAvailable){
            if(self.motionManager!.isGyroActive){
                self.motionManager!.stopGyroUpdates()
            }
        }
        gyroSensing = false
        print("gyro stopped")
    }


    
    private func startMagnetometer(){
        if(self.motionManager!.isMagnetometerAvailable){
            print("magnet is available, active\(self.motionManager!.isMagnetometerActive)")
            motionManager!.magnetometerUpdateInterval = (1.0/magnetFrequency!)
            motionManager!.startMagnetometerUpdates(to: OperationQueue())
            {data, error in
                guard let data = data else{
                    return
                }
                
                
                //event,time,x,y,z
                logw(text: "magnet,\(Utils.currentUnixTime()),\(data.magneticField.x),\(data.magneticField.y),\(data.magneticField.z)")
            }
            magnetSensing = true
        }else{
            magnetSensing = false
        }
    }
    
    private func stopMagnetometer(){
        if(motionManager!.isMagnetometerAvailable && motionManager!.isMagnetometerActive){
            motionManager!.stopMagnetometerUpdates()
        }
        magnetSensing = false
    }
    
    
    
    
    
    // MARK:- Device Motion
    private func startDeviceMotionMonitor(){
        if(self.motionManager!.isDeviceMotionAvailable){
            if(!self.motionManager!.isDeviceMotionActive){
                motionManager!.deviceMotionUpdateInterval = (1.0/devicemotionFrequency!)
                motionManager!.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
                    data, error in
                    
                    guard let data = data else{
                        return
                    }
                    
                    let userAccX:Double! = data.userAcceleration.x
                    let userAccY:Double! = data.userAcceleration.y
                    let userAccZ:Double! = data.userAcceleration.z
                    
                    let gravityX:Double! = data.gravity.x
                    let gravityY:Double! = data.gravity.y
                    let gravityZ:Double! = data.gravity.z
                    
                    let rotX:Double! = data.rotationRate.x
                    let rotY:Double! = data.rotationRate.y
                    let rotZ:Double! = data.rotationRate.z
                    
                    //event,time,userX,userY,userZ,gravityX,gravityY,gravityZ,rotationX,rotationY,rotationZ
                    logw(text: "devicemotion,\(Utils.currentUnixTime()),\(userAccX),\(userAccY),\(userAccZ),\(gravityX),\(gravityY),\(gravityZ),\(rotX),\(rotY),\(rotZ)")
                })
            }
            devicemotionSensing = true
        }else{
            devicemotionSensing = false
        }
    }
    private func stopDeviceMotionMonitor(){
        if(self.motionManager!.isDeviceMotionAvailable){
            if(self.motionManager!.isDeviceMotionActive){
                self.motionManager!.stopDeviceMotionUpdates()
            }
        }
        devicemotionSensing = false
    }
    
    

    
    //MARK:- orientation related functionalities
    private func startOrientationMonitor(){
        //println("orientation status:\(UIDevice.currentDevice().generatesDeviceOrientationNotifications)")
        if(!UIDevice.current.isGeneratingDeviceOrientationNotifications){
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        //UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        //println("orientation status:\(UIDevice.currentDevice().generatesDeviceOrientationNotifications)")
        NotificationCenter.default.addObserver(self, selector: #selector(logOrientationNotification(notification:))
            , name:UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    @objc private func logOrientationNotification(notification:NSNotification?){
        let orientation:Int? = UIDevice.current.orientation.rawValue
        var state:String!
        if(orientation == 1){
            state = "portrait"
        } else if(orientation == 2){
            state = "portrait_upside_down"
        } else if (orientation == 3){
            state = "landscap_left"
        } else if(orientation == 4){
            state = "landscape_right"
        } else if(orientation == 5){
            state = "faceup"
        } else if (orientation == 6){
            state = "facedown"
        } else{
            state = "unknown"
        }
        
        //event,time,state
        logw(text: "orientation,\(Utils.currentUnixTime()),\(state)")
        print("orientation,\(Utils.currentUnixTime()),\(state)")
    }
    
    private func stopOrientationMonitor(){
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    //MARK:- Battery State
    private func startMonitorBatteryState(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryStateEvent = true
        NotificationCenter.default.addObserver(self, selector: #selector(logBatteryStateNotification(notification:)), name:UIDevice.batteryStateDidChangeNotification, object: nil)
        
    }
    @objc private func logBatteryStateNotification(notification:NSNotification?){
        let state:Int? = UIDevice.current.batteryState.rawValue
        var status:String!
        if(state == 1){
            status = "unplugged"
        } else if (state == 2){
            status = "charging"
        } else if(state == 3){
            status = "full"
        } else {
            status = "unknown"
        }
        
        
        
        //event,time,state
        if status != nil{
            logw(text: "batterystate,\(Utils.currentUnixTime()),\(status!)")
        }
    }
    private func stopMonitorBatteryState(){
        batteryStateEvent = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryStateDidChangeNotification, object: nil)
        
        if(batteryLevelEvent == false){
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
    }
    //MARK:- Battery Level
    private func startMonitorBatteryLevel(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryLevelEvent = true
        NotificationCenter.default.addObserver(self, selector: #selector(logBatteryLevelNotification(notification:))
            , name:UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    @objc private func logBatteryLevelNotification(notification:NSNotification?){
        let level:Float! = UIDevice.current.batteryLevel
        
        //event,time,level
        if level != nil{
            NSLog("%@", "Battery level \(level * 100)")
            logw(text: "batterylevel,\(Utils.currentUnixTime()),\(level * 100)")
        }
        
    }
    private func stopMonitorBatteryLevel(){
        batteryLevelEvent = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        if(batteryStateEvent == false){
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
    }
    

    
    // MARK:- Altimeter
    private func startAltitudeMonitor(){
        if(CMAltimeter.isRelativeAltitudeAvailable()){
            altimeter?.startRelativeAltitudeUpdates(to: OperationQueue(), withHandler: {
                data, error in
                guard let data = data else{
                    return
                }
                
                //event,time,level
                logw(text: "altimeter,\(Utils.currentUnixTime()),\(data.relativeAltitude)")
            })
        }
    }
    private func stopAltitudeMonitor(){
        if(CMAltimeter.isRelativeAltitudeAvailable()){
            altimeter?.stopRelativeAltitudeUpdates()
        }
    }
    

}



