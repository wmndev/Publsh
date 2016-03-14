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
    
    class func downloadImage(fileIdentity: String, downloadingFilePath:NSURL) -> AWSTask{
        let downloadingFileURL = NSURL(fileURLWithPath: downloadingFilePath.path!)
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        
        let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest.bucket = Constants.S3_PROFILE_BUCKET
        readRequest.key =  fileIdentity
        readRequest.downloadingFileURL = downloadingFileURL
        
        return transferManager.download(readRequest)

    }
    
    
    
}
