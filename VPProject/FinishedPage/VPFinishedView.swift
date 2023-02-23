//
//  VPFinishedView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/21.
//

import UIKit

import UIColor_Hex_Swift

class VPFinishedView: UIView {
    
    var levelText:String? {
        didSet {
            gradientTextView.text = levelText
            gradientView.isHidden = !(levelText != nil && levelText!.count > 0)
        }
    }
    
    var coinCount:Int64 = 0 {
        didSet {
            excuteCoinCountAnimation()
        }
    }
    
    private var displayLink:CADisplayLink?
    private var seperateCount:Double = 0
    private var currentCount:Int64 = 0
    private let framesPerSecond:Float = 30
    private var moveWidth1:Double {
        didSet {
            moveWidth1 = moveWidth1 * 280
        }
    }
    
    private var moveWidth2:Double {
        didSet {
            moveWidth1 = moveWidth1 * 280
        }
    }
    
    private let coinBgImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "coin_bg_image")
        return imageView
    }()
    
    private let coinImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "finish_coin_icon")
        return imageView
    }()
    
    // 顶部渐变色背景
    private let gradientView:VPGradientView = {
        let borderView = VPGradientView()
        borderView.backgroundColors = [UIColor(hex6: 0x15151D, alpha: 0.11).cgColor,UIColor(hex6: 0x15151D).cgColor,UIColor(hex6: 0x15151D, alpha: 0.11).cgColor]
        borderView.gradientLineHeight = 1
        borderView.topBottomLineColors = [UIColor(hex6: 0x55D6FF, alpha: 0).cgColor,UIColor(hex6: 0x55D6FF).cgColor,UIColor(hex6: 0x55D6FF, alpha: 0).cgColor]
        borderView.isHidden = true
        return borderView
    }()
    
    // 顶部渐变色文字
    private let gradientTextView:VPGradientTextView = {
        let textView = VPGradientTextView.init()
        textView.colors = [UIColor(hex6: 0x55EBFF).cgColor,UIColor(hex6: 0x0294FE).cgColor]
        textView.font = UIFont.russoOneFont(ofSize: 26)
        return textView
    }()
    
    // 粒子动画容器
    private let emitterLayer:CAEmitterLayer = {
        let layer = CAEmitterLayer.init()
        layer.emitterMode = .surface
        layer.emitterShape = .point
        return layer
    }()
    
    // 进度条背景
    private let progressBgImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "progress_bg_image")
        return imageView
    }()
    
    // 金币数量Label
    private let coinCountLabel:VPGradientTextView = {
        let label = VPGradientTextView.init()
        label.colors = [UIColor(hex6: 0xFFF28D).cgColor,UIColor(hex6: 0xFFD20F).cgColor]
        label.font = UIFont.russoOneFont(ofSize: 26)
        return label
    }()
    
    private let progressGradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect(x: 3, y: 2, width: 0, height: 10)
        gradientLayer.cornerRadius = 5
        gradientLayer.anchorPoint = CGPointZero
        gradientLayer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        gradientLayer.shadowColor = UIColor.init(hex6: 0xFCFFDA).cgColor
        gradientLayer.shadowOffset = CGSize(width: 0, height: 1)
        gradientLayer.shadowRadius = 2
        gradientLayer.shadowOpacity = 0.5
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor(hex6: 0x6D73FF).cgColor,UIColor(hex6: 0xA13DFD).cgColor]
        return gradientLayer
    }()
    
    private let seperateLine1:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor(hex6: 0x433FFF)
        return view
    }()
    
    private let seperateLine2:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor(hex6: 0x433FFF)
        return view
    }()
    
    private let seperateLine3:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor(hex6: 0x433FFF)
        return view
    }()
    
    private let levelLabel1:UILabel = {
        let label = UILabel.init()
        label.text = "Normal"
        label.textColor = UIColor(hex6: 0xA471FE)
        label.font = UIFont.russoOneFont(ofSize: 12)
        return label
    }()
    
    private let levelLabel2:UILabel = {
        let label = UILabel.init()
        label.text = "Good"
        label.textColor = UIColor(hex6: 0x807BFF)
        label.font = UIFont.russoOneFont(ofSize: 12)
        return label
    }()
    
    private let levelLabel3:UILabel = {
        let label = UILabel.init()
        label.text = "Excellent"
        label.textColor = UIColor(hex6: 0x807BFF)
        label.font = UIFont.russoOneFont(ofSize: 12)
        return label
    }()
    
    private let reportButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = .green
        button.setTitle("Report", for: .normal)
        return button
    }()
    
    private let basicAnimation:CABasicAnimation = {
        let animation = CABasicAnimation()
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.keyPath = "bounds"
        animation.fillMode = .forwards
        return animation
    }()
    
    //MARK: —— View life cycle
    init(moveWidth1:Double,moveWidth2:Double) {
        self.moveWidth1 = moveWidth1
        self.moveWidth2 = moveWidth2
        super.init(frame: CGRectZero)
        
        alpha = 0
        backgroundColor = UIColor.clear
        
        addVisualEffectView()
        addCoinBackgroundImageView()
        addEmitterLayer()
        addCoinImageView()
        addGradientView()
        addGradientTextView()
        addCoinCountLabel()
        addProgressBgImageView()
        addGradientLayer()
        addSeperateLineView()
        addLevelLabel()
        addReportButton()
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        } completion: { isFinished in
            if isFinished {
                self.excuteCoinImageViewScaleAnimation()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitterLayer.frame = coinBgImageView.frame
        emitterLayer.emitterPosition = CGPoint(x: emitterLayer.bounds.size.width/2, y: emitterLayer.bounds.size.height/2)
    }
    
    deinit {
        print("VPFinishedView deinit")
    }
    
    //MARK: —— Action
    @objc func countAction() {
        currentCount += Int64(seperateCount)
        if currentCount >= coinCount {
            currentCount = coinCount
            displayLink?.invalidate()
        }
        coinCountLabel.text = "+\(currentCount)"
    }
    
    @objc private func reportButtonClick() {
        print("reportButtonClick")
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { isFinished in
            if isFinished {
                self.removeFromSuperview()
            }
        }
    }
    
    //MARK: —— Private method
    private func addVisualEffectView() {
        let visualEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let visualEffectView = UIVisualEffectView.init(effect: visualEffect)
        addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addCoinBackgroundImageView() {
        addSubview(coinBgImageView)
        coinBgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self).offset(-50)
            make.size.equalTo(283)
        }
    }
    
    private func addEmitterLayer() {
        layer.insertSublayer(emitterLayer, above: coinBgImageView.layer)
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = 100
        emitterCell.velocity = 10
        emitterCell.scale = 0.2
        emitterCell.velocityRange = 200
        emitterCell.emissionRange = CGFloat.pi * 2
        emitterCell.lifetime = 1
        emitterCell.contents = UIImage(named: "emitter_dot_icon")?.cgImage
        emitterLayer.emitterCells = [emitterCell]
    }
    
    private func addCoinImageView() {
        addSubview(coinImageView)
        coinImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self).offset(-50)
            make.size.equalTo(124)
        }
    }
    
    private func addGradientView() {
        addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(28)
            make.right.equalTo(self.snp.right).offset(-28)
            make.height.equalTo(52)
            make.bottom.equalTo(coinBgImageView.snp.top).offset(-20)
        }
    }
    
    private func addGradientTextView() {
        addSubview(gradientTextView)
        gradientTextView.snp.makeConstraints { make in
            make.centerX.equalTo(gradientView.snp.centerX)
            make.centerY.equalTo(gradientView.snp.centerY)
        }
    }
    
    private func addCoinCountLabel() {
        addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints { make in
            make.top.equalTo(coinBgImageView.snp.bottom).offset(-25)
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.centerX.equalTo(coinBgImageView.snp.centerX)
        }
    }
    
    private func addSeperateLineView() {
        progressBgImageView.addSubview(seperateLine1)
        seperateLine1.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerX.equalTo(progressBgImageView.snp.centerX).multipliedBy(0.5)
            make.centerY.equalTo(progressBgImageView.snp.centerY)
        }
        
        progressBgImageView.addSubview(seperateLine2)
        seperateLine2.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerX.equalTo(progressBgImageView.snp.centerX)
            make.centerY.equalTo(progressBgImageView.snp.centerY)
        }
        
        progressBgImageView.addSubview(seperateLine3)
        seperateLine3.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerX.equalTo(progressBgImageView.snp.centerX).multipliedBy(1.5)
            make.centerY.equalTo(progressBgImageView.snp.centerY)
        }
    }
    
    private func addProgressBgImageView() {
        addSubview(progressBgImageView)
        progressBgImageView.snp.makeConstraints { make in
            make.top.equalTo(coinBgImageView.snp.bottom).offset(30)
            make.height.equalTo(28)
            make.width.equalTo(280)
            make.centerX.equalTo(self)
        }
    }
    
    private func addGradientLayer() {
        progressBgImageView.layer.addSublayer(progressGradientLayer)
        excuteGradientLayerWidthAnimation(fromSize: CGSize(width: 0, height: 10), toSize: CGSize(width: 150, height: 10))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
            self.excuteGradientLayerWidthAnimation(fromSize: CGSize(width: 150, height: 10), toSize: CGSize(width: 260, height: 10))
            self.alphaAnimation(for: self.levelLabel3)
        })
    }
    
    private func addLevelLabel() {
        addSubview(levelLabel1)
        levelLabel1.snp.makeConstraints { make in
            make.top.equalTo(progressBgImageView.snp.bottom).offset(5)
            make.centerX.equalTo(seperateLine1.snp.centerX)
        }
        
        addSubview(levelLabel2)
        levelLabel2.snp.makeConstraints { make in
            make.top.equalTo(progressBgImageView.snp.bottom).offset(5)
            make.centerX.equalTo(seperateLine2.snp.centerX)
        }
        
        addSubview(levelLabel3)
        levelLabel3.snp.makeConstraints { make in
            make.top.equalTo(progressBgImageView.snp.bottom).offset(5)
            make.centerX.equalTo(seperateLine3.snp.centerX)
        }
    }
    
    private func addReportButton() {
        reportButton.addTarget(self, action: #selector(reportButtonClick), for: .touchUpInside)
        addSubview(reportButton)
        reportButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(32)
            make.right.equalTo(self.snp.right).offset(-32)
            make.height.equalTo(48)
            make.top.equalTo(levelLabel1.snp.bottom).offset(30)
        }
    }
    
    private func excuteCoinImageViewScaleAnimation() {
        UIView.animate(withDuration: 0.4) {
            self.coinImageView.transform = CGAffineTransformMakeScale(1.4, 1.4)
        } completion: { isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.4) {
                    self.coinImageView.transform = CGAffineTransformIdentity
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.emitterLayer.removeFromSuperlayer()
                })
            }
        }
    }
    
    private func excuteGradientLayerWidthAnimation(fromSize:CGSize, toSize:CGSize) {
        basicAnimation.fromValue = NSValue.init(cgRect: CGRect(origin: CGPointZero, size: fromSize))
        basicAnimation.toValue = NSValue.init(cgRect: CGRect(origin: CGPointZero, size: toSize))
        progressGradientLayer.add(basicAnimation, forKey: nil)
    }
    
    private func excuteCoinCountAnimation() {
        seperateCount = Double(self.coinCount) / (Double(framesPerSecond * 2))
        if (seperateCount < 1) {
            seperateCount = 1
        }
        if displayLink != nil {
            displayLink?.invalidate()
        }
        displayLink = CADisplayLink(target: self, selector: #selector(countAction))
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: framesPerSecond, maximum: framesPerSecond)
        } else {
            displayLink?.preferredFramesPerSecond = Int(framesPerSecond)
        }
        displayLink?.add(to: .current, forMode: .common)
    }
    
    private func alphaAnimation(for view:UIView) {
        let basicAnimation = CABasicAnimation.init()
        basicAnimation.keyPath = "opacity"
        basicAnimation.duration = 1
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.repeatCount = 2
        view.layer.add(basicAnimation, forKey: nil)
    }
}
