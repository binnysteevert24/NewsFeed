//
//  NFImageView+UIImageView.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import UIKit

extension UIImageView  {
    
    fileprivate static var imageDownloadQueue: DispatchQueue?
    
    fileprivate static let releaseImages = {
        // Release
        imageDownloadQueue = nil
    }
    /// image download from web service manager
    final func image(_ url: URL, completionHandler: ((UIImage)->())? = nil, failure:(()->())? = nil) {
        
        if UIImageView.imageDownloadQueue == nil {
            
            UIImageView.imageDownloadQueue = DispatchQueue(label: NFDispatchQueueLabel.imageDownload, qos: DispatchQoS.userInitiated)
        }
        
        let work = DispatchWorkItem {
            
            NFWebServiceManager.aSynchronousRequest(NFWebServiceManager.NFRequestType.imageURLPath(url), completionHandler: {  (responseData) in
                
                switch (responseData) {
                    
                case let .imageData(data):
                    
                    if let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async(execute: DispatchWorkItem {
                            
                            completionHandler?(image)
                        })
                    }
                    else {
                        print("image download failure Error : ")
                        if let errorHandler = failure {
                            DispatchQueue.main.async(execute:errorHandler)
                        }
                    }
                default:
                    print("image download failure Error : ")
                    
                    if let errorHandler = failure {
                        DispatchQueue.main.async(execute:errorHandler)
                    }
                }
            })
        }
        UIImageView.imageDownloadQueue?.async(execute: work)
    }
}
