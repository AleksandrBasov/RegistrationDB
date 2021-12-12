//
//  FirstViewController.swift
//  Registration
//
//  Created by Александр Басов on 11/9/21.
//

import UIKit
import AVKit

class FirstViewController: UIViewController {

    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    // MARK: - UI
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
}

// MARK: - setUpElements
private extension FirstViewController {
    func  setUpElements() {
        Utilities.styleFieldButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
}

// MARK: - setUpVideo
private extension FirstViewController {
    func setUpVideo() {
        let bundlePath = Bundle.main.path(forResource: "Welcome", ofType: "mp4")
        guard bundlePath != nil else{
            return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        
        let item = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 1)
    }
}
