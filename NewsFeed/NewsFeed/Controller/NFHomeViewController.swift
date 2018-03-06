//
//  NFHomeViewController.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import UIKit

/// Home page contain button to show news content
class NFHomeViewController: UIViewController {
    
    private let button: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    /**
     initial configuration.
     */
    func configure() {
        
        title = "Home"
        view.backgroundColor = UIColor.white
        
        button.setTitle("News", for: .normal)
        button.addTarget(self, action: #selector(NFHomeViewController.newsButtonClick(_:)), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.gray
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = ["button": button] as [String : Any]
        
        let descHorizontal = "|-(30)-[button]-(30)-|"
        let descVertical = "V:|-(<=200)-[button(100)]"
        
        let descHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descHorizontal,
                                                                       options: NSLayoutFormatOptions.alignAllCenterY,
                                                                       metrics: nil,
                                                                       views: viewsDict)
        let descVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descVertical,
                                                                     options: .alignAllCenterX,
                                                                     metrics: nil,
                                                                     views: viewsDict)
        self.view.addConstraints(descHorizontalConstraints)
        self.view.addConstraints(descVerticalConstraints)
        
    }
    
    /**
     news button touch up inside event handler.
     
     - parameter sender: button object.
     */
    @objc private func newsButtonClick(_ sender: UIButton) {
        
        self.navigationController?.pushViewController(NFNewsViewController(), animated: true)
    }
    
}
