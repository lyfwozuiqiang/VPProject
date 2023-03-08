//
//  VPIdentitySelectController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/7.
//

import UIKit

import AVFoundation

class VPIdentitySelectController: UIViewController {
    
    private var player:AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true
        view.backgroundColor = .white
        
        playBackgroundMedia()
        layoutUserInterface()
        NotificationCenter.default.addObserver(self, selector: #selector(playEndNofication), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    deinit {
        print("VPIdentitySelectController deinit")
    }
    
    // MARK: —— Notification
    @objc private func playEndNofication() {
        player?.seek(to: CMTime(value: 0, timescale: 1))
        player?.play()
    }
    
    // MARK: —— Private method
    // 播放背景动画
    private func playBackgroundMedia() {
        let mediaPath:String? = Bundle.main.path(forResource: "background_media", ofType: "mp4")
        if mediaPath != nil {
            let urlPath:URL = NSURL.fileURL(withPath: mediaPath!) as URL
            let playItem:AVPlayerItem = AVPlayerItem(url: urlPath)
            let player = AVPlayer(playerItem: playItem)
            let playerLayer = AVPlayerLayer.init(player: player)
            playerLayer.frame = UIScreen.main.bounds
            playerLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(playerLayer)
            player.play()
            self.player = player
            let visualEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let visualEffectView = UIVisualEffectView.init(effect: visualEffect)
            visualEffectView.alpha = 0.2
            view.addSubview(visualEffectView)
            visualEffectView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func layoutUserInterface() {
        let idSelectView = VPIdentitySelectView.init()
        idSelectView.personality = "Lựa chọn nhân vật của bạn"
        idSelectView.dataSource = ["1","1","1","1","1"]
        idSelectView.backButtonClickHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        idSelectView.enterButtonClickHandler = { index in
            print("enterButtonClickHandler index = ",index)
        }
        idSelectView.alpha = 0
        view.addSubview(idSelectView)
        idSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            idSelectView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            idSelectView.dataSource = ["1","1","1"]
        })
    }
}
