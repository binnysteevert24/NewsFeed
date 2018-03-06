//
//  NFWebServiceManager.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import Foundation
/** Builder class to pass object to configure environment and timout for webservice
 */
final class NFBuilder {
    
    typealias BuilderClosure = ((_ builder: NFBuilder) -> ())
    
    var environment: NFWebServiceManager.NFEnvironment?
    var timeOut: Float?
    
    convenience init(_ builder: BuilderClosure)  {
        self.init()
        
        builder(self)
    }
}
///
/** This is to handle webservice request and response in the app.
 web service manager restricted to the web service so it hides request data
 */
final class NFWebServiceManager {
    
    /// requesting url constant
    fileprivate struct ServiceCall {
        
        static let newFeedURLPath = "/s/2iodh4vg0eortkl/facts.json"
        static let devBaseURLPath = "https://dl.dropboxusercontent.com"
    }
    /// request type
    enum NFRequestType {
        
        case newsFeed
        case imageURLPath(URL)
        
        func requestedURL() -> URL?  {
            
            let requestType: NFRequestType = self
            var URLPath: String = ""
            
            switch requestType {
                
            case .newsFeed:
                
                if let environment = NFWebServiceManager.builder?.environment {
                    
                    URLPath = environment.path() + ServiceCall.newFeedURLPath
                }
                
            case let .imageURLPath(imageURL):
                
                return imageURL
            }
            return URL(string: URLPath)
        }
    }
    /// response data type
    enum NFResponseData {
        
        case errorData(Error)
        case responseData(Data)
        case unKnownError
    }
    /// response type
    enum NFResponseType {
        
        case newsFeed(NFNews)
        case error(Error)
        case unknownError
    }
    
    /// environment ddata type
    enum NFEnvironment {
        
        case mock, development, production, staging
        
        func path() -> String {
            
            switch self {
                
            case .development:
                return ServiceCall.devBaseURLPath
                
            default:
                return ServiceCall.devBaseURLPath
            }
        }
    }
    
    fileprivate static var builder: NFBuilder!
    /// configure web service manager using builder
    class func configuration(_ builder: NFBuilder) {
        
        if (NFWebServiceManager.builder == nil) {
            NFWebServiceManager.builder = builder
        }
    }
    
    typealias CallBackHandler = ((NFResponseData) -> ())
    
    /**
     asynchronous Request to handle webservice call.
     
     - parameter requestType: requesting type to get appropriete response.
     - parameter completionHandler: call back handler.
     
     */
    class func request(_ requestType: NFRequestType, completionHandler: CallBackHandler?) {
        
        guard let requestURL = requestType.requestedURL() else {
            
            print("Invalid URL")
            return
        }
        let timeOut = NFWebServiceManager.builder?.timeOut ?? 10.0
        let request = URLRequest(url:  requestURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: TimeInterval(timeOut))
        
        let queue: OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response, data, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            guard let data = data else {
                completionHandler?(NFResponseData.unKnownError)
                return
            }
            if (error != nil || httpResponse?.statusCode == 200) {
                
                completionHandler?(NFResponseData.responseData(data))
            }
            else {
                completionHandler?(NFResponseData.unKnownError)
            }
        })
    }
    
}
