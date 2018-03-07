//
//  NFViewController+UIViewController.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import Foundation

protocol NFViewController {
    
}

fileprivate struct NFInjector {
    
    static let webServiceQueue: DispatchQueue = DispatchQueue(label: NFDispatchQueueLabel.webService, qos: DispatchQoS.userInitiated)
}
extension NFViewController {
    
    var webServiceQueue: DispatchQueue { get { return NFInjector.webServiceQueue } }
}
/// This web service request only available to the class restricted to others
extension NFViewController where Self : NFNewsViewController  {
    
    /// request web service for getting news feed
    func requestNewsFeed(completionHandler: @escaping ((NFWebServiceManager.NFResponseType) -> ())) {
        
        let work = DispatchWorkItem {
            
            NFWebServiceManager.aSynchronousRequest(NFWebServiceManager.NFRequestType.newsFeed, completionHandler: { (responseData) in
                
                DispatchQueue.main.async(execute:{
                    completionHandler(responseData)
                })
            })
        }
        webServiceQueue.async(execute: work)
    }
}

