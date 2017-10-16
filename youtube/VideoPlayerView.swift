//
//  VideoPlayerView.swift
//  MyYouTube
//
//  Created by Paul Dong on 1/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//


import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let videoPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
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
    
    let resizeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.zPosition = 1
        button.addTarget(self, action: #selector(handleResize), for: .touchUpInside)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.zPosition = 1
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMainView()
        setupPlayerView()
        setupGradientLayer()

        addSubview(controlsContainerView)
        controlsContainerView.frame = videoPlayerView.frame

        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor).isActive = true

        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        controlsContainerView.addSubview(videoTimeLabel)
        videoTimeLabel.leftAnchor.constraint(equalTo: videoPlayerView.leftAnchor, constant: 5).isActive = true
        videoTimeLabel.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor).isActive = true
        videoTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: videoPlayerView.rightAnchor, constant: -5).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        controlsContainerView.addSubview(videoSlider)
        videoSlider.leftAnchor.constraint(equalTo: videoTimeLabel.rightAnchor, constant: 5).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor).isActive = true
        videoSlider.widthAnchor.constraint(equalToConstant: frame.width - 50 - 50 - 20).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        setupStopButton()
        
//        backgroundColor = UIColor.black
    }
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    func setupMainView(){

        if let keyWindow = UIApplication.shared.keyWindow {
            addSubview(self.mainView)
            


            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.mainView.frame = keyWindow.frame
            }, completion: { (completed) in
                UIApplication.shared.isStatusBarHidden = true
            })
        }
    }
    
    func setupStopButton(){
        addSubview(self.resizeButton)
        self.resizeButton.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        self.resizeButton.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        mainView.bringSubview(toFront: resizeButton)
    }
    
    private func setupPlayerView(){
        
        mainView.addSubview(videoPlayerView)
        let height = mainView.frame.width * 9 / 16
        let frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: height)
        videoPlayerView.frame = frame
        
        if let filePath = Bundle.main.path(forResource: "conway", ofType: "mp4") {
            
            let url = URL(fileURLWithPath: filePath)
            player = AVPlayer(url: url)
            
            if let plyr = player {
                playerLayer = AVPlayerLayer(player: plyr)
                
                if let pLayer = playerLayer {
                    self.videoPlayerView.layer.addSublayer(pLayer)
                    pLayer.frame = self.videoPlayerView.frame
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
        gradientLayer.frame = controlsContainerView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleResize(){
        print("handleDismiss")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let height = self.mainView.frame.height
            let playerHeight = CGFloat(300 / 16 * 9)
            let width = self.mainView.frame.width
            let frame = CGRect(x: width - 300, y: height - playerHeight, width: 300, height: height)
            self.mainView.frame = frame
            self.resizeButton.removeFromSuperview()
            self.controlsContainerView.removeFromSuperview()
            
            self.playerLayer?.preferredFrameSize()
            
            self.addSubview(self.closeButton)
            self.closeButton.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -5).isActive = true
            self.closeButton.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: -5).isActive = true
        }, completion: { (completed) in
            UIApplication.shared.isStatusBarHidden = true
        })
    }
    
    func handleClose(){
        print("handleClose")
        if let plr = player {
            plr.pause()
        }
        player = nil
        closeButton.removeFromSuperview()
        controlsContainerView.removeFromSuperview()
        mainView.removeFromSuperview()
    }
}
