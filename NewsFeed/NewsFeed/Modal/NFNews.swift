//
//  News.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import Foundation
/// News feed object
final class NFNews {
    
    private(set) var title: String! = nil
    private(set) var rows: [NFItem]! = []
 
    /// dictionary to object
    convenience init(dictionary: [String:Any?]) {
        self.init()
        
        self.title = dictionary[NFConstant.title] as? String ?? ""
        
        for itemDictionary in dictionary[NFConstant.rows] as? [[String: String?]] ?? [] {
            
            let item = NFItem(dictionary: itemDictionary)
            rows.append(item)
        }
    }
}


