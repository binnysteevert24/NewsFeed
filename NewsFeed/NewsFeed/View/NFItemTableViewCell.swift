//
//  NFItemTableViewCell.swift
//  NewsFeed
//
//  Created by Ravikumar on 3/6/18.
//  Copyright © 2018 Binny. All rights reserved.
//

import UIKit
/// items cell to view content. It is handled using View-Modal
class NFItemTableViewCell: UITableViewCell {

let nameLabel = UILabel()
let detailLabel = UILabel()
var authorImageView = UIImageView()

    fileprivate enum NFCellType {
        case placeholder
        case newsFeed
    }
    
// MARK: Initalizers
override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(authorImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(detailLabel)
    
    // configure authorImageView
    
    authorImageView.translatesAutoresizingMaskIntoConstraints = false
    authorImageView.backgroundColor = UIColor.lightGray
    authorImageView.contentMode = .scaleAspectFit
    
    // configure nameLabel
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.numberOfLines = 0
    nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
    
    // configure detailLabel
    
    detailLabel.translatesAutoresizingMaskIntoConstraints = false
    detailLabel.numberOfLines = 0
    detailLabel.font = UIFont(name: "Avenir-Book", size: 12)
    detailLabel.textColor = UIColor.gray
    
    let authorImageViewHorizontal = "H:|-[authorImageView]-|"
    let nameLabelHorizontal = "H:|-[nameLabel]-|"
    let detailLabelHorizontal = "H:|-[detailLabel]-|"
    
    let authorImageViewVertical = "V:|-[authorImageView]"
    let nameLabelVertical = "V:[authorImageView]-[nameLabel]"
    let detailLabelVertical = "V:[nameLabel]-[detailLabel]-|"
    
    let viewsDict = ["contentView": contentView, "authorImageView": authorImageView, "nameLabel": nameLabel, "detailLabel": detailLabel] as [String : Any]
    
    let authorImageViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: authorImageViewHorizontal,
                                                                              options: NSLayoutFormatOptions.alignAllCenterY,
                                                                              metrics: nil,
                                                                              views: viewsDict)
    let nameLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: nameLabelHorizontal,
                                                                        options: NSLayoutFormatOptions.alignAllCenterY,
                                                                        metrics: nil,
                                                                        views: viewsDict)
    let detailLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: detailLabelHorizontal,
                                                                          options: NSLayoutFormatOptions.alignAllCenterY,
                                                                          metrics: nil,
                                                                          views: viewsDict)
    
    let authorImageViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: authorImageViewVertical,
                                                                            options: .alignAllCenterX,
                                                                            metrics: nil,
                                                                            views: viewsDict)
    let nameLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: nameLabelVertical,
                                                                      options: .alignAllCenterX,
                                                                      metrics: nil,
                                                                      views: viewsDict)
    let detailLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: detailLabelVertical,
                                                                        options: .alignAllCenterX,
                                                                        metrics: nil,
                                                                        views: viewsDict)
    
    contentView.addConstraints(authorImageViewHorizontalConstraints)
    contentView.addConstraints(nameLabelHorizontalConstraints)
    contentView.addConstraints(detailLabelHorizontalConstraints)
    
    contentView.addConstraints(authorImageViewVerticalConstraints)
    contentView.addConstraints(nameLabelVerticalConstraints)
    contentView.addConstraints(detailLabelVerticalConstraints)
}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
override func layoutSubviews() {
    super.layoutSubviews()
    
    self.contentView.layoutIfNeeded()
}

private func setupCell(_ cellType: NFCellType) {
    
    let imageBackgroundColor: UIColor = (cellType == .newsFeed) ? UIColor.black : UIColor.lightGray
    let textBackgroundColor: UIColor = (cellType == .newsFeed) ? UIColor.white : UIColor.lightGray
    
    authorImageView.backgroundColor = imageBackgroundColor
    nameLabel.backgroundColor = textBackgroundColor
    detailLabel.backgroundColor = textBackgroundColor
}
    /** configure vire items that is view modal of Item then download the image
    from web and set handler to viewcontroller
*/
func configure(_ viewItem: NFViewItem, completionHandler: (()->())? = nil) {
    
    setupCell(.newsFeed)
    self.nameLabel.text = viewItem.item.title
    self.detailLabel.text = viewItem.item.description
    
    switch (viewItem.imageStatus) {
        
    case .initial:
        if let placeHolderImage = UIImage(named: "placeHolderImage") {
            
            viewItem.imageStatus = .placeHolder(placeHolderImage)
            self.authorImageView.image = placeHolderImage
        }
        else {
            viewItem.imageStatus = .noImage
            self.authorImageView.image = nil
        }
        completionHandler?()
    default: break
    }
    
    switch (viewItem.imageStatus) {
        
    case .placeHolder(_):
        
        if let URLPath = viewItem.item.imageURLPath , let imageURL = URL(string: URLPath) {
            
            self.authorImageView.image(imageURL, completionHandler: { (image) in
                
                viewItem.imageStatus = .downloaded(image)
                self.authorImageView.image = image
                
                completionHandler?()
                
            }, failure:{
                
                viewItem.imageStatus = .noImage
                self.authorImageView.image = nil
                
                completionHandler?()
            })
        }
        else {
            viewItem.imageStatus = .noImage
            self.authorImageView.image = nil
            completionHandler?()
            
        }
    case .initial:
        if let placeHolderImage = UIImage(named: "placeHolderImage") {
            
            viewItem.imageStatus = .placeHolder(placeHolderImage)
            self.authorImageView.image = placeHolderImage
        }
        else {
            viewItem.imageStatus = .noImage
            self.authorImageView.image = nil
        }
        completionHandler?()
        
    case let .downloaded(image):
        self.authorImageView.image = image
    default:
        self.authorImageView.image = nil
        completionHandler?()
    }
}
    /// configure placeholder data
    func configure(_ item: NFItem) {
        
        setupCell(.placeholder)
        self.nameLabel.text = item.title
        self.detailLabel.text = item.description
        
        if let placeHolderImage = UIImage(named: "placeHolderImage") {
            self.authorImageView.image = placeHolderImage
        }
    }
}



