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
            
            NFWebServiceManager.request(NFWebServiceManager.NFRequestType.newsFeed) { (responseData) in
                
                switch (responseData) {
                    
                case let .responseData(data):
                    
                    do {
                        guard let latinString = String.init(data: data, encoding: String.Encoding.isoLatin1),
                            let encodedData = latinString.data(using: String.Encoding.utf8),
                            let jsonResult = try JSONSerialization.jsonObject(with: encodedData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: Any?] else {
                                
                                completionHandler(NFWebServiceManager.NFResponseType.unknownError)
                                return
                        }
                        
                        print("ASynchronous\(String(describing: jsonResult))")
                        
                        let news = NFNews.init(dictionary: jsonResult)
                        DispatchQueue.main.async {
                            completionHandler(.newsFeed(news))
                        }
                    }
                    catch let error {
                        print("Json Parsig error :\(error.localizedDescription)")
                        completionHandler(.error(error))
                    }
                case let .errorData(error):
                    print("webservice Error : \(error)")
                case .unKnownError: break
                }
            }
        }
        webServiceQueue.async(execute: work)
    }
}

