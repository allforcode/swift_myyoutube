//
//  Setting.swift
//  swift_myyoutube
//
//  Created by Paul Dong on 17/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}
