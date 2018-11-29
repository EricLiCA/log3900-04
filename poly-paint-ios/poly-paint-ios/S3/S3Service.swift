//
//  S3Service.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-16.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import AWSS3
import AWSCore

class S3Service {
    static let instance = S3Service()
    let accessKey = "AKIAIPDXLQHFFWAOQNXQ"
    let secretKey = "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"
    var credentialsProvider: AWSStaticCredentialsProvider
    var serviceConfiguration: AWSServiceConfiguration
    var transferManager: AWSS3TransferManager
    
    private init() {
        credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        serviceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = serviceConfiguration
        transferManager = AWSS3TransferManager.default()
    }
    
    func upload(image: UIImage) {
        // Create a URL in the /tmp directory
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") else {
            return
        }
        
        // save image to URL
        do {
            try UIImageJPEGRepresentation(image, 0.1)?.write(to: imageURL)
            //try UIImagePNGRepresentation(image)?.write(to: imageURL)
        } catch { }
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = imageURL
        uploadRequest?.bucket = "polypaintpro"
        uploadRequest?.key = "profile-pictures/\(UserDefaults.standard.string(forKey: "username")!).jpeg"
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as? NSError {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \(uploadRequest!.key) Error: \(error)")
                    }
                } else {
                    print("Error uploading: \(uploadRequest!.key) Error: \(error)")
                }
                return nil
            }
            
            let uploadOutput = task.result
            print("Upload complete for: \(uploadRequest!.key)")
            return nil
        })
    }
}
