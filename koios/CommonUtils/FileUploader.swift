//
//  FileUploader.swift
//  cimonv2
//
//  Created by Afzal Hossain on 1/24/19.
//  Copyright © 2019 Afzal Hossain. All rights reserved.
//

import Foundation
import Alamofire


class FileUploader: NSObject {
    
    
    override init() {
        
    }
    
    func uploadDataFile(){
        print("log directory ------- \(Log.defaultDirectory())")
        let files = FCFileManager.listFilesInDirectory(atPath: Log.defaultDirectory(), withExtension: "csv")
        print("number of files in log \(files?.count)")
        for file in files!{
            if let filePath: String = file as? String{
                print("file name :\(filePath)")
                
                // User "authentication":
                let parameters = ["contentType":"multipart/form-data"]
                let url = "https://speechmarker.com/markerinterface/files/upload/"
                
                // Use Alamofire to upload the image
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(URL(fileURLWithPath: filePath), withName: "file")
                        //multipartFormData.append(rainbowImageURL, withName: "rainbow")
                        for (key, val) in parameters {
                            multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                        }
                },
                    to: url,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                //debugPrint(response)
                                print("upload success -------  \(response)")
                            }
                        case .failure(let encodingError):
                            print("upload error \(encodingError)")
                        }
                }
                )
            }
            
            break
        }
    }
}
