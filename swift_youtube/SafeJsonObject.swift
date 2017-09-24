//
//  SafeJsonObject.swift
//  MyYouTube
//
//  Created by Paul Dong on 24/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let newKey = underscoreToCamelCase(key)
        
        let selector = NSSelectorFromString("set\(newKey):")
        
        let responds = self.responds(to: selector)
        
        if !responds {
            return
        }
        
        super.setValue(value, forKey: newKey)
    }
    
    func underscoreToCamelCase(_ string: String) -> String {
        return string.components(separatedBy: "_").map { (s) -> String in
            let first = String(describing: s.characters.first!).capitalized
            let others = String(s.characters.dropFirst())
            return first + others
            }.joined()
    }
}
