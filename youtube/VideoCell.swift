//
//  VideoCell.swift
//  swift_myyoutube
//
//  Created by Paul Dong on 10/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
            setupThumbnailImage()

            setupProfileImage()
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let subtitleText = "\(channelName) ● \(numberFormatter.string(for: numberOfViews)!) ● 2 years ago "
                subtitleTextView.text = subtitleText
            }
            
            //measure title text
            if let title = video?.title{
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleHeightConstrain?.constant = 44
                }else{
                    titleHeightConstrain?.constant = 20
                }
            }
        }
    }
    
    func setupThumbnailImage(){
        if let thumbnailImageUrl = video?.thumbnailImageName {
            self.thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    func setupProfileImage(){
        if let profileImageUrl = video?.channel?.profileImageName {
            self.userProfileImageView.loadImageUsingUrlString(urlString: profileImageUrl)
        }
    }

    let thumbnailImageView: CustomUIImageView = {
        let imageView = CustomUIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomUIImageView = {
        let imageView = CustomUIImageView()
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    var titleHeightConstrain: NSLayoutConstraint?

    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraints(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        
        addConstraints(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraints(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        addConstraints(format: "H:|[v0]|", views: separatorView)
        
        titleHeightConstrain = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)

        addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy:.equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8),
            
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8),
            
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0),
            
            titleHeightConstrain!,
            
            NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy:.equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4),
            
            NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8),
            
            NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30)
        ])
    }
}
