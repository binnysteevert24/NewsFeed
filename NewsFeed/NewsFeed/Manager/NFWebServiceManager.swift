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
        case responseJSON([String: Any?])
        case responseData(Data)
        case unKnownError
    }
    /// response type
    enum NFResponseType {
        
        case newsFeed(NFNews)
        case imageData(Data)
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
    fileprivate class func request(_ requestType: NFRequestType, completionHandler: CallBackHandler?) {
        
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
    
    class func aSynchronousRequest(_ requestType: NFRequestType, completionHandler: @escaping ((NFWebServiceManager.NFResponseType) -> ())) {
        
        NFWebServiceManager.request(requestType) {(responseData) in
            
            switch (responseData) {
                
            case let .responseData(data):
                
                switch (requestType) {
                    
                case .newsFeed:
                    
                    let responseJSONData: NFResponseData = NFWebServiceManager.unwrappingResponse(data: data)
                    
                    if case let .responseJSON(jsonResult) = responseJSONData {
                        
                        let news = NFNews(dictionary: jsonResult)
                        completionHandler(.newsFeed(news))
                    }
                    else if case let .errorData(error) = responseJSONData {
                        completionHandler(.error(error))
                    }
                    else {
                        completionHandler(.unknownError)
                    }
                    print("parsing Error : \(responseJSONData)")
                    
                case .imageURLPath(_):
                    
                    completionHandler(.imageData(data))
                }
            case let .errorData(error):
                completionHandler(.error(error))
            case .unKnownError:
                completionHandler(.unknownError)
            default: break
            }
        }
    }
    
    fileprivate class func unwrappingResponse(data: Data) -> NFResponseData {
        
        do {
            guard let latinString = String.init(data: data, encoding: String.Encoding.isoLatin1),
                let encodedData = latinString.data(using: String.Encoding.utf8),
                let jsonResult = try JSONSerialization.jsonObject(with: encodedData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: Any?] else {
                    
                    return .unKnownError
            }
            return .responseJSON(jsonResult)
        }
        catch let error {
            return .errorData(error)
        }
    }
}
