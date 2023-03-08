//
//  VPGuideProcessController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/4.
//

import UIKit

import AVFoundation

class VPGuideProcessController: UIViewController {
    
    // 眨眼动画上半部分图层相关
    let topLayerToPath:UIBezierPath = UIBezierPath.init()
    let topLayerFromPath:UIBezierPath = UIBezierPath.init()
    let topShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = UIColor(hex6: 0x0F0F1A).cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowRadius = 50
        return shapeLayer
    }()
    
    // 眨眼动画下半部分图层相关
    let bottomLayerToPath:UIBezierPath = UIBezierPath.init()
    let bottomLayerFromPath:UIBezierPath = UIBezierPath.init()
    let bottomShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = UIColor(hex6: 0x0F0F1A).cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowRadius = 50
        return shapeLayer
    }()
    
    private let dragonBaseImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(named: "guide_dragon_base_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let dragonImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "guide_clear_dragon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let guideMessageBgImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(named: "guide_message_bg_image"))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        return imageView
    }()
    
    private let messageStartIndicatorImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(named: "guide_start_message_icon"))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        return imageView
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel.init()
        label.alpha = 0
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let messageLabel:UILabel = {
        let label = UILabel.init()
        label.alpha = 0
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private let nextButton:UICommonButton = {
        let button = UICommonButton.init(style: .gradientPurple)
        button.updateTitle("Next")
        button.alpha = 0
        return button
    }()
        
    private let space:CGFloat = 80
    // 曲线控制点距离中间距离
    private let controlPointSpace:CGFloat = 350
    
    private var displayLink:CADisplayLink?
    private var titleString:String = "Welcome to Mastar Space!"
    private var currentTitle:String = ""
    private var messageString:String = "Bạn đã nhập vào Không gian Mastar！"
    private var currentMessage:String = ""
    private var step:Int = 0
    
    private var player:AVPlayer?
    
    private var tapGesture:UITapGestureRecognizer?
    
    // MARK: —— Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapHandle))
        view.addGestureRecognizer(tapGesture!)
        // 播放背景视频
        playBackgroundMedia()
        NotificationCenter.default.addObserver(self, selector: #selector(playEndNofication), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        // 布局用户页面
        layoutUserInterface()
        // 第一次睁眼动画
        firstOpenAnimation()
    }
    
    // MARK: —— Notification
    @objc private func playEndNofication() {
        player?.seek(to: CMTime(value: 0, timescale: 1))
        player?.play()
    }
    
    // MARK: —— Acion
    @objc private func viewTapHandle() {
        if displayLink?.isPaused == true {
            return
        }
        displayLink?.isPaused = true
        tapGesture?.isEnabled = false
        titleLabel.text = titleString
        messageLabel.text = messageString
        if step == 0 {
            step2Setting()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [self] in
                tapGesture?.isEnabled = true
            })
        } else if step == 1 {
            step3Setting()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [self] in
                tapGesture?.isEnabled = true
            })
        } else if step == 2 {
            addNextButton()
        }
    }
    
    @objc private func displayLinkAcion() {
        if currentTitle.count < titleString.count && titleString.count > 0 {
            let index = currentTitle.count + 1
            currentTitle = String(titleString.prefix(index))
            titleLabel.text = currentTitle
        }
        
        if currentMessage.count < messageString.count && messageString.count > 0 && currentTitle.count == titleString.count {
            let index = currentMessage.count + 1
            currentMessage = String(messageString.prefix(index))
            messageLabel.text = currentMessage
            if currentMessage.count == messageString.count {
                if step == 0 {
                    step2Setting()
                } else if step == 1 {
                    step3Setting()
                }
                return
            }
        }
        if step == 2 && currentMessage.count == messageString.count {
            addNextButton()
        }
    }
    
    @objc private func nextButtonClick() {
        let selectVc = VPIdentitySelectController.init()
        navigationController?.pushViewController(selectVc, animated: true)
    }
    
    // MARK: —— Private method
    // 布局页面
    private func layoutUserInterface() {
        view.addSubview(dragonBaseImageView)
        dragonBaseImageView.snp.makeConstraints { make in
            make.width.equalTo(327)
            make.height.equalTo(75)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(dragonImageView)
        dragonImageView.snp.makeConstraints { make in
            make.width.equalTo(232)
            make.height.equalTo(206)
            make.bottom.equalToSuperview().offset(-47)
            make.centerX.equalToSuperview()
        }
        
        // 初始展示黑色遮罩
        let mainScreenSize = UIScreen.main.bounds
        view.layer.addSublayer(topShapeLayer)
        topLayerFromPath.move(to: CGPoint(x: 0, y: 0))
        topLayerFromPath.addLine(to: CGPoint(x: 0, y: mainScreenSize.height/2))
        topLayerFromPath.addQuadCurve(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height/2), controlPoint: CGPoint(x: mainScreenSize.width/2, y: mainScreenSize.height/2))
        topLayerFromPath.addLine(to: CGPoint(x: mainScreenSize.width, y: 0))
        topShapeLayer.path = topLayerFromPath.cgPath
        
        view.layer.addSublayer(bottomShapeLayer)
        bottomLayerFromPath.move(to: CGPoint(x: 0, y: mainScreenSize.height/2))
        bottomLayerFromPath.addLine(to: CGPoint(x: 0, y: mainScreenSize.height))
        bottomLayerFromPath.addLine(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height))
        bottomLayerFromPath.addLine(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height/2))
        bottomLayerFromPath.addQuadCurve(to: CGPoint(x: 0, y: mainScreenSize.height/2), controlPoint: CGPoint(x: mainScreenSize.width/2, y: mainScreenSize.height/2))
        bottomShapeLayer.path = bottomLayerFromPath.cgPath
    }
    
    private func step2Setting() {
        displayLink?.isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [self] in
            step = 1
            currentTitle = ""
            titleString =  "Here, you'll learn English immersively, and I will be with you."
            messageLabel.text = ""
            currentMessage = ""
            messageString = "Tại đây, bạn có thể vừa học tiếng Anh vừa trải nghiệm một hành trình hoàn toàn mới trong cuộc đời."
            displayLink?.isPaused = false
        })
    }
    
    private func step3Setting() {
        displayLink?.isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [self] in
            step = 2
            currentTitle = ""
            titleString =  "Now, choose a role and begin a new life."
            messageLabel.text = ""
            currentMessage = ""
            messageString = "Bây giờ, hãy chọn một nhân vật và thay đổi cuộc sống của anh / cô thông qua sự lựa chọn của bạn."
            displayLink?.isPaused = false
        })
    }
    
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
    
    // 第一次睁眼动画
    private func firstOpenAnimation() {
        let mainScreenSize = UIScreen.main.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
            topLayerToPath.move(to: CGPoint(x: 0, y: 0))
            topLayerToPath.addLine(to: CGPoint(x: 0, y: mainScreenSize.height/2 - space))
            topLayerToPath.addQuadCurve(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height/2 - space), controlPoint: CGPoint(x: mainScreenSize.width/2, y: mainScreenSize.height/2 - controlPointSpace))
            topLayerToPath.addLine(to: CGPoint(x: mainScreenSize.width, y: 0))
            let topPathAnimation = pathAnimation(fromValue: topLayerFromPath.cgPath, toValue: topLayerToPath.cgPath)
            let topShadowAnimation = shadowOpacityAnimation(fromValue: 0, toValue: 1)
            let topGroupAnimation = groupAnimation(animations: [topPathAnimation,topShadowAnimation],delay: 0)
            topShapeLayer.add(topGroupAnimation, forKey: nil)
            
            bottomLayerToPath.move(to: CGPoint(x: 0, y: mainScreenSize.height/2 + space))
            bottomLayerToPath.addLine(to: CGPoint(x: 0, y: mainScreenSize.height))
            bottomLayerToPath.addLine(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height))
            bottomLayerToPath.addLine(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height/2 + space))
            bottomLayerToPath.addQuadCurve(to: CGPoint(x: 0, y: mainScreenSize.height/2 + space), controlPoint: CGPoint(x: mainScreenSize.width/2, y: mainScreenSize.height/2 + controlPointSpace))
            
            let bottomLayerPathAnimation = pathAnimation(fromValue: bottomLayerFromPath.cgPath, toValue: bottomLayerToPath.cgPath)
            let bottomLayerShadowAnimation = shadowOpacityAnimation(fromValue: 0, toValue: 1)
            let bottomLayerGroupAnimation = groupAnimation(animations: [bottomLayerPathAnimation,bottomLayerShadowAnimation], delay: 0)
            bottomShapeLayer.add(bottomLayerGroupAnimation, forKey: nil)

            firstCloseAnimation()
        })
    }
    
    // 第一次闭眼动画
    private func firstCloseAnimation() {
        // 闭眼动画
        let topPathAnimation2 = pathAnimation(fromValue: topLayerToPath.cgPath, toValue: topLayerFromPath.cgPath)
        let topShadowAnimation2 = shadowOpacityAnimation(fromValue: 1, toValue: 0)
        let topGroupAnimation2 = groupAnimation(animations: [topPathAnimation2,topShadowAnimation2],delay: 0.6)
        topShapeLayer.add(topGroupAnimation2, forKey: nil)
        
        let bottomPathAnimation2 = pathAnimation(fromValue: bottomLayerToPath.cgPath, toValue: bottomLayerFromPath.cgPath)
        let bottomShadowAnimation2 = shadowOpacityAnimation(fromValue: 1, toValue: 0)
        let bottomGroupAnimation2 = groupAnimation(animations: [bottomPathAnimation2,bottomShadowAnimation2],delay: 0.6)
        bottomShapeLayer.add(bottomGroupAnimation2, forKey: nil)
        
        secondOpenAnimation()
    }
    
    // 第二次睁眼动画
    private func secondOpenAnimation() {
        let delayTime:CFTimeInterval = 1.6
        let topPathAnimation = pathAnimation(fromValue: topLayerFromPath.cgPath, toValue: topLayerToPath.cgPath)
        let topShadowAnimation = shadowOpacityAnimation(fromValue: 0, toValue: 1)
        let topGroupAnimation = groupAnimation(animations: [topPathAnimation,topShadowAnimation],delay: delayTime)
        topShapeLayer.add(topGroupAnimation, forKey: nil)
        
        let bottomLayerPathAnimation = pathAnimation(fromValue: bottomLayerFromPath.cgPath, toValue: bottomLayerToPath.cgPath)
        let bottomLayerShadowAnimation = shadowOpacityAnimation(fromValue: 0, toValue: 1)
        let bottomLayerGroupAnimation = groupAnimation(animations: [bottomLayerPathAnimation,bottomLayerShadowAnimation], delay: delayTime)
        bottomShapeLayer.add(bottomLayerGroupAnimation, forKey: nil)
        
        endAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: {
            self.addWakeUpWords()
        })
    }
    
    // 第二次睁眼后结束动画
    private func endAnimation() {
        let mainScreenSize = UIScreen.main.bounds
        let topEndPath:UIBezierPath = UIBezierPath.init()
        topEndPath.move(to: CGPoint(x: 0, y: 0))
        topEndPath.addLine(to: CGPoint(x: 0, y: 0))
        topEndPath.addQuadCurve(to: CGPoint(x: mainScreenSize.width, y: 0), controlPoint: CGPoint(x: mainScreenSize.width/2, y:  -controlPointSpace))
        topEndPath.addLine(to: CGPoint(x: mainScreenSize.width, y: 0))
        let topPathAnimation = pathAnimation(fromValue: topLayerToPath.cgPath, toValue: topEndPath.cgPath)
        let topShadowAnimation = shadowOpacityAnimation(fromValue: 1, toValue: 0)
        let delayTime:CFTimeInterval = 2.1
        let topGroupAnimation = groupAnimation(animations: [topPathAnimation,topShadowAnimation],delay: delayTime)
        topShapeLayer.add(topGroupAnimation, forKey: nil)
        
        let bottomEndPath:UIBezierPath = UIBezierPath.init()
        bottomEndPath.move(to: CGPoint(x: 0, y: mainScreenSize.height + space))
        bottomEndPath.addLine(to: CGPoint(x: 0, y: mainScreenSize.height))
        bottomEndPath.addLine(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height))
        bottomEndPath.addLine(to: CGPoint(x: mainScreenSize.width, y: mainScreenSize.height + space))
        bottomEndPath.addQuadCurve(to: CGPoint(x: 0, y: mainScreenSize.height + space), controlPoint: CGPoint(x: mainScreenSize.width/2, y: mainScreenSize.height + controlPointSpace))
        let bottomPathAnimation = pathAnimation(fromValue: bottomLayerToPath.cgPath, toValue: bottomEndPath.cgPath)
        let bottomShadowAnimation = shadowOpacityAnimation(fromValue: 1, toValue: 0)
        let bottomGroupAnimation = groupAnimation(animations: [bottomPathAnimation,bottomShadowAnimation],delay: delayTime)
        bottomShapeLayer.add(bottomGroupAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.addGuideMessageBgImageViewAndIndicatorImageView()
        })
    }
    
    // 睁眼闭眼路径动画
    private func pathAnimation(fromValue:Any, toValue:Any) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        return basicAnimation
    }
    
    // 睁眼闭眼透明度动画
    private func shadowOpacityAnimation(fromValue:Any, toValue:Any) -> CABasicAnimation{
        let basicAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        basicAnimation.fromValue = 1
        basicAnimation.toValue = 1
        return basicAnimation
    }
    
    // 睁眼闭眼透组合动画
    private func groupAnimation(animations:Array<CABasicAnimation>,delay:CFTimeInterval) -> CAAnimationGroup {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.5
        groupAnimation.beginTime = CACurrentMediaTime() + delay
        groupAnimation.fillMode = .forwards
        groupAnimation.animations = animations
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return groupAnimation
    }
    
    private func addGuideMessageBgImageViewAndIndicatorImageView() {
        view.addSubview(guideMessageBgImageView)
        guideMessageBgImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(dragonImageView.snp.top).offset(-30)
        }
        
        view.addSubview(messageStartIndicatorImageView)
        messageStartIndicatorImageView.snp.makeConstraints { make in
            make.left.equalTo(guideMessageBgImageView.snp.left).offset(28)
            make.top.equalTo(guideMessageBgImageView.snp.top).offset(72)
            make.width.equalTo(10)
            make.height.equalTo(22)
        }
        
        addTitleLabelAndMessageLabel()
        
        UIView.animate(withDuration: 0.5) {
            self.guideMessageBgImageView.alpha = 1
            self.messageStartIndicatorImageView.alpha = 1
        }
    }
    
    private func addTitleLabelAndMessageLabel() {
        titleLabel.text = currentTitle
        guideMessageBgImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(messageStartIndicatorImageView.snp.right).offset(12)
            make.right.equalTo(guideMessageBgImageView.snp.right).offset(-32)
            make.top.equalTo(messageStartIndicatorImageView.snp.top)
            make.height.greaterThanOrEqualTo(23)
        }
        
        messageLabel.text = currentMessage
        guideMessageBgImageView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.greaterThanOrEqualTo(23)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 1
            self.messageLabel.alpha = 1
        } completion: { [self] _ in
            self.displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAcion))
            if #available(iOS 15.0, *) {
                self.displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
            } else {
                self.displayLink?.preferredFramesPerSecond = 60
            }
            self.displayLink?.add(to: .current, forMode: .common)
        }
    }
    
    // 添加 next 按钮
    private func addNextButton() {
        guideMessageBgImageView.isUserInteractionEnabled = true
        guideMessageBgImageView.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        nextButton.snp.makeConstraints { make in
            make.left.equalTo(guideMessageBgImageView).offset(48)
            make.right.equalTo(guideMessageBgImageView).offset(-48)
            make.height.equalTo(48)
            make.bottom.equalTo(guideMessageBgImageView.snp.bottom).offset(-60)
        }
        UIView.animate(withDuration: 0.3) {
            self.nextButton.alpha = 1
        }
    }
    
    // 添加 wake up 提示
    private func addWakeUpWords() {
        let topWakeLabel:UILabel = UILabel.init()
        topWakeLabel.alpha = 0
        topWakeLabel.text = "Wake up"
        topWakeLabel.textColor = .white
        topWakeLabel.font = UIFont.russoOneFont(ofSize: 24)
        view.addSubview(topWakeLabel)
        topWakeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let imageView:UIImageView = UIImageView(image: UIImage(named: "guide_start_message_icon")?.withRenderingMode(.alwaysOriginal))
        imageView.alpha = 0
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(22)
            make.centerY.equalTo(topWakeLabel.snp.centerY)
            make.right.equalTo(topWakeLabel.snp.left).offset(-5)
        }
        
        let lineView:UIView = UIView.init()
        lineView.backgroundColor = UIColor(hex6: 0x69E4F6)
        lineView.layer.cornerRadius = 1
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(24)
            make.left.equalTo(topWakeLabel.snp.right).offset(5)
            make.centerY.equalTo(topWakeLabel.snp.centerY)
        }
        
        let bottomWakeLabel:UILabel = UILabel.init()
        bottomWakeLabel.alpha = 0
        bottomWakeLabel.text = "Thức dậy"
        bottomWakeLabel.textColor = .white
        bottomWakeLabel.font = UIFont.montserratRegularFont(ofSize: 16)
        view.addSubview(bottomWakeLabel)
        bottomWakeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topWakeLabel.snp.bottom).offset(8)
        }
        
        UIView.animate(withDuration: 0.3) {
            imageView.alpha = 1
            topWakeLabel.alpha = 1
            bottomWakeLabel.alpha = 1
        }
        
        let opacityAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.5
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.isRemovedOnCompletion = true
        opacityAnimation.repeatCount = 5
        lineView.layer.add(opacityAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            topWakeLabel.removeFromSuperview()
            imageView.removeFromSuperview()
            lineView.removeFromSuperview()
            bottomWakeLabel.removeFromSuperview()
        })
    }
}
