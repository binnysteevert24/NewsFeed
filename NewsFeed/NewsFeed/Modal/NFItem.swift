//
//  Item.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import Foundation
/// Item of news feed object
final  class NFItem {
    
    private(set) var title: String!
    private(set) var description: String!
    private(set) var imageURLPath: String?
    /// dictionary to object
    convenience init(dictionary: [String:String?]) {
        self.init()
        
        self.title = dictionary[NFConstant.title] ?? ""
        self.description = dictionary[NFConstant.description] ?? ""
        self.imageURLPath = dictionary[NFConstant.imageURLPath] ?? nil
    }
    convenience init(item: NFItem) {
        self.init()
        
        self.description = item.description
        self.title = item.title
        self.imageURLPath = item.imageURLPath
    }
}
