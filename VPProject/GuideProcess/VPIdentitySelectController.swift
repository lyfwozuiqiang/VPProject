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
    private let identitySelectView:VPIdentitySelectView = VPIdentitySelectView.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true
        view.backgroundColor = .white
        // 播放背景视屏
        playBackgroundMedia()
        // 布局用户界面
        layoutUserInterface()
        // 获取并处理角色数据
        dealIdentityRoleResponse()
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
    
    // MARK: —— Network
    private func getIdentityRoleRequest() async -> IdentityResponse? {
        guard let fileUrl = Bundle.main.url(forResource: "IdentityData", withExtension: "json") else {
            return nil
        }
        if let jsonData = try? Data(contentsOf: fileUrl) {
            let response = try? JSONDecoder().decode(IdentityResponse.self, from: jsonData)
            return response
        } else {
            return nil
        }
    }
    
    private func dealIdentityRoleResponse() {
        Task {
            let response = await getIdentityRoleRequest()
            if response?.data?.count ?? 0 > 0 {
                identitySelectView.dataSource = response?.data ?? []
            } else {
                let alertController = UIAlertController(title: "", message: "Oops! Data is lost. Please try again later.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Retry", style: .default) { _ in
                    self.dealIdentityRoleResponse()
                }
                alertController.addAction(action)
                present(alertController, animated: true)
            }
        }
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
        identitySelectView.backButtonClickHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        identitySelectView.enterButtonClickHandler = { index in
            print("enterButtonClickHandler index = ",index)
        }
        identitySelectView.alpha = 0
        view.addSubview(identitySelectView)
        identitySelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.identitySelectView.alpha = 1
        }
    }
}
