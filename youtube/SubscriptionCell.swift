//
//  SubscriptionCell.swift
//  MyYouTube
//
//  Created by Paul Dong on 24/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
