//
//  NFNewsViewController.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import UIKit
/// This class is to request news content from web and show the content
class NFNewsViewController: UIViewController, NFViewController {

    fileprivate let bookCellReuseIdentifier = "BookTableViewCellIdentifier"
    fileprivate var newsList: [Any]!
    fileprivate let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      let news = NFNews.placeHolder()
        title = news.title
       newsList = news.rows
        
        configureTableView()
        
        loadNewsData()
    }
    /**
     initial configuration.
     */
    func configureTableView() {
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(NFItemTableViewCell.self, forCellReuseIdentifier: bookCellReuseIdentifier)
        
        view.addSubview(tableView)
        
        ///set tableView constraints programmatically
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let descHorizontal = "H:|[tableView]|"
        
        let descVertical = "V:|[tableView]|"
        
        let viewsDict = ["tableView": tableView]
        
        let tableViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descHorizontal,
                                                                            options: NSLayoutFormatOptions.alignAllCenterY,
                                                                            metrics: nil,
                                                                            views: viewsDict)
        
        let tableViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descVertical,
                                                                          options: .alignAllCenterX,
                                                                          metrics: nil,
                                                                          views: viewsDict)
        self.view.addConstraints(tableViewVerticalConstraints)
        self.view.addConstraints(tableViewHorizontalConstraints)
        //
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        }
        else {
            tableView.addSubview(refreshControl)
        }
    }
    
    /**
     refresh content of the tableview while user pull to refresh.
     
     - parameter refreshControl: sender object.
     */
    @objc private func refreshTableView(refreshControl: UIRefreshControl) {
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
        
        loadNewsData()
    }
    
    /**
     request news data to webservice.
     
     - parameter completionHandler: once response received it will intimate to the requestor.
     */
    func loadNewsData(_ completionHandler: (()->())? = nil)  {
        
        requestNewsFeed { [weak self](response) in
            
            switch (response) {
                
            case let .newsFeed(news):
                
                self?.title = news.title
                
                let oldViewItems = self?.newsList as? [NFViewItem]
                
                /// Configure view modal object from Item object and if its same data keep image alive in memory
                if let viewItems = news.viewItems(oldViewItems: oldViewItems) {
                    
                    self?.newsList = viewItems
                    self?.tableView.reloadData()
                }
   
                
            case let .error(error):
                print("webservice Error  : \(error)")
            case .unknownError: break
            }
            
            completionHandler?()
        }
    }
}

/// datasource handle in extension
/** Update UI for resize cell height and keep image data in View-Modal object alive in memory
 */
extension NFNewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: bookCellReuseIdentifier, for: indexPath) as? NFItemTableViewCell {
            
            if let item = newsList[(indexPath as NSIndexPath).row] as? NFItem {
                
                cell.configure(item)
            }
            else if let viewItem = newsList[(indexPath as NSIndexPath).row] as? NFViewItem {
                
                cell.configure(viewItem, completionHandler: { [weak cell, weak self] in
                    
                    guard let cell = cell, let indexPath = self?.tableView.indexPath(for: cell)  else {
                        return
                    }
                    
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                })
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}
