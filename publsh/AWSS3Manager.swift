//
//  AWSS3Manager.swift
//  publsh
//
//  Created by Itai Wiseman on 2/13/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation
import UIKit


class AWSS3Manager{
    
    
    class func uploadImage(image: UIImage, fileIdentity: String){
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        //let test = NSURL(
        let testFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("temp")
        let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
        let data = UIImageJPEGRepresentation(image, 0.5)
        data!.writeToURL(testFileURL1, atomically: true)
        uploadRequest1.bucket = Constants.S3_PROFILE_BUCKET
        uploadRequest1.key =  fileIdentity
        uploadRequest1.body = testFileURL1
        
        let task = transferManager.upload(uploadRequest1)
        task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Upload successful")
            }
            return nil
        }
        
    }
    
    class func downloadImage(fileIdentity: String){
        let downloadingFilePath1 = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("temp-download")
        let downloadingFileURL1 = NSURL(fileURLWithPath: downloadingFilePath1.path!)
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        
        let readRequest1 : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest1.bucket = Constants.S3_PROFILE_BUCKET
        readRequest1.key =  fileIdentity
        readRequest1.downloadingFileURL = downloadingFileURL1
        
        let task = transferManager.download(readRequest1)
        task.continueWithBlock { (task) -> AnyObject! in
            print(task.error)
            if task.error != nil {
            } else {
                dispatch_async(dispatch_get_main_queue()
                    , { () ->  Void in
                        print("downloaded image")
//                        self.selectedImage.image = UIImage(contentsOfFile: downloadingFilePath1)
//                        self.selectedImage.setNeedsDisplay()
//                        self.selectedImage.reloadInputViews()
                        
                })
                print("Fetched image")
            }
            return nil
        }
    }
    
    
    
}
