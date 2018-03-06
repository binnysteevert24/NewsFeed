//
//  ViewItem.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import UIKit
/// View Modal of Item
final class NFViewItem {
    
    enum NFImageItemStatus {
        
        case initial
        case noImage
        case placeHolder(UIImage)
        case downloaded(UIImage)
    }
    
    private var _imageStatus: NFImageItemStatus = .initial
    let item: NFItem!
    
    var imageStatus: NFImageItemStatus {
        
        set (value) {
            switch (_imageStatus) {
            case .initial, .placeHolder(_):
                _imageStatus = value
            default: break
            }
        }
        get {
            return _imageStatus
        }
    }
    
    init(item: NFItem) {
        self.item = item
    }
}

/// add functionality to News
extension NFNews {
    
    /// convert news object to View-Modal of News object
    func viewItems( oldViewItems: [NFViewItem]? = nil) -> [NFViewItem]? {
        
        let items = self.rows
        
        let viewItems = items?.map{ [weak self] (item) -> NFViewItem in
            
            let viewItem = NFViewItem(item: item)
            
            if let rows = self?.rows,
                oldViewItems?.count == rows.count,
                let index = rows.index(where: {$0 === item}),
                let oldViewItem = oldViewItems?[index] {
                
                viewItem.imageStatus = oldViewItem.imageStatus
            }
            return viewItem
        }
        return viewItems
    }
    /// placeholder object for news
  class func placeHolder() -> NFNews {
        
        let itemDictionary: [String: String] = ["title": "\t\t\t", ",description": "    \t\n\t\n\t\n", "imageHref": ""]
        let newsDictionary = ["title": "About Canada", "rows": [itemDictionary, itemDictionary, itemDictionary]] as [String : Any]
        let placeHolderItems = NFNews.init(dictionary: newsDictionary)
        
        return placeHolderItems
    }
}

