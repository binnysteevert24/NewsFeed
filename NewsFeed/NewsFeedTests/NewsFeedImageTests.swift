//
//  NewsFeedImageTests.swift
//  NewsFeedTests
//
//  Created by Ravikumar on 3/9/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import XCTest
@testable import NewsFeed

class NewsFeedImageTests: XCTestCase {
    
    var imageView: UIImageView!
    var builder: NFBuilder!
    
    override func setUp() {
        super.setUp()
        
        imageView = UIImageView()
        
        builder = NFBuilder { builder in
            builder.environment = .development
            builder.timeOut = 5.0
        }
        NFWebServiceManager.configuration(builder)
    }
    
    override func tearDown() {
        
        builder = nil
        imageView = nil
        super.tearDown()
    }
    
    // Asynchronous test: success
    func testValidImageURL() {
        
        imageDownload(imageURLPath: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg")
    }
    
    func imageDownload(imageURLPath: String?) {
        
        let promise = expectation(description: "Successfully Image downloaded ")
        
        if let URLPath = imageURLPath , let imageURL = URL(string: URLPath) {
            
            imageView.image(imageURL, completionHandler: { (image) in
                
                promise.fulfill()
                
            }, failure:{
                
                XCTFail("image download error")
                
            })
        }
        else {
            XCTFail("No valid image URL")
        }
        waitForExpectations(timeout: 5, handler: { (error) in
            
        })
    }
}
