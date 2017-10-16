//
//  CustomClasses.swift
//  swift_myyoutube
//
//  Created by Paul Dong on 17/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomUIImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)

        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url! , completionHandler: { (data, urlResponse, error) in
            if let err = error {
                print(err)
            }
        
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                
            }
        }).resume()
    }
}
