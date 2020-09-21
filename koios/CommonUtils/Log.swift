//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Log.swift
//
//  Created by Dalton Cherry on 12/23/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//  Simple logging class.
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

let key = "20E9475FECE29056201406863B7E809F"


///The log class containing all the needed methods
@objc public class Log:NSObject {
    
    ///The max size a log file can be in Kilobytes. Default is 5*1024 (5 MB)
    public var maxFileSize: UInt64 = 1 * 1024
    
    ///The max number of log file that will be stored. Once this point is reached, the oldest file is deleted.
    public var maxFileCount = 1
    
    ///The directory in which the log files will be written
    public var directory = Log.defaultDirectory()
    
    //The name of the log files.
    public var name = "logfile"
    
    //Background Queue
    //public var logBackgroundQueue:DispatchQueue? = dispatch_queue_create("cimon.logqueue", DISPATCH_QUEUE_SERIAL)
    public var logBackgroundQueue:DispatchQueue? = DispatchQueue(label: "koios.logqueue")
    
    ///logging singleton
    @objc public class var logger: Log {
        
        struct Static {
            static let instance: Log = Log()
        }
        return Static.instance
    }
    //the date formatter
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }
    
    /*func encryptionByAES(rawText:String)->String{
        var message = rawText
        let mod = (message.characters.count) % 16
        if (mod != 0){
            let c = 16 - mod
            for _ in 0..<c{
                message = message + " "//String(Character(UnicodeScalar(c)))
            }
        }
        return AESCrypt.encrypt(message, password: key)
    }*/
    
    ///write content to the current log file.
    @objc public func write(text: String) {
        self.logBackgroundQueue?.async {
            let path = "\(self.directory)/\(self.logName(num: 0))"
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: path) {
                do{
                    try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
                } catch let error as NSError{
                    print("An error occured..\(error)")
                }
                
            }
            if let fileHandle = FileHandle(forWritingAtPath: path) {
                //let dateStr = dateFormatter.stringFromDate(NSDate())
                //let writeText = "[\(dateStr)]: \(text)\n"
                var writeText:String!
                //if(SwiftUtils.stringIsEmpty(CurrentLabel)){
                writeText = "\(text)\n"
                //} else{
                //writeText = "\(text),label:\(CurrentLabel)"
                //}
                //writeText = self.encryptionByAES(rawText: writeText) + "\n"
                //writeText = writeText + "\n"
                fileHandle.seekToEndOfFile()
                fileHandle.write(writeText.data(using: String.Encoding.utf8)!)
                fileHandle.closeFile()
                //Logger.debug(writeText)
                self.cleanup()
            }
        }
    }
    ///do the checks and cleanup
    func cleanup() {
        let path = "\(directory)/\(logName(num: 0))"
        let size = fileSize(path: path)
        let maxSize: UInt64 = maxFileSize*1024
        if size > 0 && size >= maxSize && maxSize > 0 && maxFileCount > 0 {
            //rename(0)
            //move current log file as ftp file
            moveToFtpLocation(index: 0)
            
            //delete the oldest file
            /*let deletePath = "\(directory)/\(logName(maxFileCount))"
             let fileManager = NSFileManager.defaultManager()
             fileManager.removeItemAtPath(deletePath, error: nil)*/
        }
    }
    
    ///check the size of a file
    func fileSize(path: String) -> UInt64 {
        let fileManager = FileManager.default
        let attrs: NSDictionary? = try! fileManager.attributesOfItem(atPath: path) as NSDictionary?
        if let dict = attrs {
            return dict.fileSize()
        }
        return 0
    }
    
    ///Recursive method call to rename log files
    func rename(index: Int) {
        let fileManager = FileManager.default
        let path = "\(directory)/\(logName(num: index))"
        let newPath = "\(directory)/\(logName(num: index+1))"
        if fileManager.fileExists(atPath: newPath) {
            rename(index: index+1)
        }
        do{
            try fileManager.moveItem(atPath: path, toPath: newPath)
        } catch let error as NSError{
            print("An error occured..\(error)")
        }
        
    }
    
    ///gets the log name
    func logName(num :Int) -> String {
        return "\(name)-\(num).log"
    }
    
    ///get the default log directory
    class func defaultDirectory() -> String {
        var path = ""
        let fileManager = FileManager.default
        #if os(iOS)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        path = "\(paths[0])/Logs"
        #elseif os(OSX)
        let urls = fileManager.URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)
        if let url = urls.last as? NSURL {
            if let p = url.path {
                path = "\(p)/Logs"
            }
        }
        #endif
        if !fileManager.fileExists(atPath: path) && path != ""  {
            do{
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError{
                print("An error occured..\(error)")
            }
            
        }
        return path
    }
    ///gets the log name
    func ftpName() -> String {
        return  "\(Utils.getDeviceIdentifier())_\(Utils.currentUnixTime()).csv"
    }
    
    //move to ftp folder location
    func moveToFtpLocation(index: Int){
        let fileManager = FileManager.default
        let path = "\(directory)/\(logName(num: index))"
        let newPath = "\(directory)/\(ftpName())"
        do{
            try fileManager.moveItem(atPath: path, toPath: newPath)
        } catch let error as NSError{
            print("An error occured..\(error)")
        }
        
        
    }
    
}

///a free function to make writing to the log much nicer
public func logw(text: String) {
    Log.logger.write(text: text)
}

