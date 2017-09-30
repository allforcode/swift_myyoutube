//
//  VideoLauncher.swift
//  MyYouTube
//
//  Created by Paul Dong on 24/09/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    var isPlaying = false
    
    func handlePause(){
        if let plyr = player {
            
            if isPlaying {
                plyr.pause()
                pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            } else {
                plyr.play()
                pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            }
            
            isPlaying = !isPlaying
        }
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    let videoTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.thumbTintColor = .red
        let image = UIImage(named: "thumb")
        slider.setThumbImage(image, for: .normal)
        slider.setThumbImage(image, for: .highlighted)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    func handleSliderChange(){
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = CMTimeValue(Float64(videoSlider.value) * totalSeconds)
            let seekTime = CMTime(value: value, timescale: 1)
            self.player?.seek(to: seekTime)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        setupGradientLayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        controlsContainerView.addSubview(videoTimeLabel)
        videoTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        videoTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.leftAnchor.constraint(equalTo: videoTimeLabel.rightAnchor, constant: 5).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.widthAnchor.constraint(equalToConstant: frame.width - 50 - 50 - 20).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        backgroundColor = UIColor.black
    }

    var player: AVPlayer?
    
    private func setupPlayerView(){
        
        if let filePath = Bundle.main.path(forResource: "conway", ofType: "mp4") {
            
            let url = URL(fileURLWithPath: filePath)
//            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726")!
            player = AVPlayer(url: url)
            
            if let plyr = player {
                let playerLayer = AVPlayerLayer(player: plyr)
                self.layer.addSublayer(playerLayer)
                playerLayer.frame = self.frame
                print("playing....")
                plyr.play()
                
                plyr.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
                
                //track player progress
                let interval = CMTime(value: 1, timescale: 2)
                plyr.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                    self.videoTimeLabel.text = self.formatTimeString(duration: progressTime)
                    
                    //lets move the slider thumb
                    if let duration = self.player?.currentItem?.duration{
                        let durationSeconds = CMTimeGetSeconds(duration)
                        self.videoSlider.value = Float( CMTimeGetSeconds(progressTime ) / durationSeconds )
                    }
                })
                
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = keyPath, key == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration{
                videoLengthLabel.text = formatTimeString(duration: duration)
            }
        }
    }
    
    private func formatTimeString(duration: CMTime) -> String {
        let seconds = CMTimeGetSeconds(duration)
    
        let secondsText = String(format: "%02d", Int(seconds) % 60)
        let minutesText = String(format: "%02d", Int(seconds) / 60)
        return "\(minutesText):\(secondsText)"
    }
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer(){
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.width, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: frame)
            
            view.addSubview(videoPlayerView)
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                view.frame = keyWindow.frame
            
            }, completion: { (completed) in
                UIApplication.shared.isStatusBarHidden = true
            })
        }
    }
}
