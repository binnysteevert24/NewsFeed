//
//  NewsFeedTests.swift
//  NewsFeedTests
//
//  Created by Ravikumar on 3/9/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import XCTest

@testable import NewsFeed


class NewsFeedTests: XCTestCase {
    var newsViewController: NFNewsViewController!
    var builder: NFBuilder!
    
    override func setUp() {
        super.setUp()
        
        newsViewController = NFNewsViewController()
        
        builder = NFBuilder { builder in
            builder.environment = .development
            builder.timeOut = 5.0
        }
        NFWebServiceManager.configuration(builder)
    }
    
    override func tearDown() {
        newsViewController = nil
        builder = nil
        
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidWebServiceCall() {
        
        let promise = expectation(description: "Response type .newsFeed with News object")
        
        newsViewController.requestNewsFeed { (response) in
            
            switch (response) {
                
            case .newsFeed(_):
                
                promise.fulfill()
                
            case let .error(error):
                
                XCTFail("Webservice error: \(error.localizedDescription)")
                
                print("webservice Error  : \(error)")
            default:
                
                XCTFail("Webservice error: \(response)")
                
                print("webservice Error")
            }
        }
        
        waitForExpectations(timeout: 5, handler: { (error) in
            
            
        })
    }
}

