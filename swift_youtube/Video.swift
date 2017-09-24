//
//  Video.swift
//  swift_myyoutube
//
//  Created by Paul Dong on 16/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class Video: SafeJsonObject {
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel" {
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String : AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
}
