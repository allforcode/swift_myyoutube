//
//  VideoLauncher.swift
//  MyYouTube
//
//  Created by Paul Dong on 24/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class VideoLauncher: NSObject {

    
    func showVideoPlayer(){
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            let videoPlayerView = VideoPlayerView(frame: keyWindow.frame)
            
            
            keyWindow.addSubview(videoPlayerView)
//
//            view.addSubview(self.closeButton)
//            self.closeButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//            self.closeButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            self.closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//            self.closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//            view.bringSubview(toFront: closeButton)
//            keyWindow.addSubview(view)
//
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                videoPlayerView.frame = keyWindow.frame
            }, completion: { (completed) in
                UIApplication.shared.isStatusBarHidden = true
            })
        }
    }
 
}
