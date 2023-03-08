//
//  VPIdentitySelectView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/5.
//  身份选择View

import UIKit

class VPIdentitySelectView: UIView,UIScrollViewDelegate {
    
    var personality:String = "" {
        didSet {
            personalityLabel.text = personality
        }
    }
    
    var dataSource:[String] = [] {
        didSet {
            for view in identityScrollView.subviews {
                if view.tag > 0 {
                    view.removeFromSuperview()
                }
            }
            let contentWidth:Double = (UIScreen.main.bounds.self.width - 84) * Double(dataSource.count)
            identityScrollView.contentSize = CGSize(width:contentWidth, height: 0)
            var tempItem:UIView?
            for (index,item) in dataSource.enumerated() {
                let identityView = VPIdentityView()
                identityView.tag = index + 10
                identityScrollView.addSubview(identityView)
                identityView.snp.makeConstraints { make in
                    if tempItem == nil {
                        make.left.equalTo(identityScrollView.snp.left)
                    } else {
                        make.left.equalTo(tempItem!.snp.right)
                    }
                    make.centerY.equalTo(identityScrollView.snp.centerY)
                    make.width.equalTo(identityScrollView.snp.width)
                    make.height.equalTo(348)
                    tempItem = identityView
                }
            }
        }
    }
    
    var backButtonClickHandler:(()->Void)?
    var enterButtonClickHandler:((Int)->Void)?
    
    private let topGradientView:VPGradientView = {
        let view = VPGradientView.init()
        view.backgroundColors = [UIColor(hex6: 0x4F6EF4,alpha: 0).cgColor,UIColor(hex6: 0x4F6EF4).cgColor,UIColor(hex6: 0x4F6EF4,alpha: 0).cgColor]
        return view
    }()
    
    private let topLineImageView:UIImageView = {
        let imageView:UIImageView = UIImageView.init(image: UIImage(named: "guide_line_bg_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let personalityLabel:UILabel = {
        let label:UILabel = UILabel.init()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let identityScrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let enterButton:UICommonButton = {
        let enterButton:UICommonButton = UICommonButton.init(style: .gradientPurple)
        enterButton.updateTitle("Enter")
        enterButton.titleLabel?.font = UIFont.montserratRegularFont(ofSize: 18)
        return enterButton
    }()
    
    private var currentIndex:Int = 0
    
    // MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        layoutUserInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: —— Action
    @objc private func backButtonClick() {
        backButtonClickHandler?()
    }
    
    @objc private func enterButtonClick(button:UIButton) {
        if button.isEnabled {
            identityScrollView.clipsToBounds = true
            excuteLayerAnimation(for: button)
            enableEnterButton(enable: false)
            let currentView = identityScrollView.viewWithTag(Int(currentIndex) + 10)
            UIView.animate(withDuration: 0.3) {
                currentView?.transform = CGAffineTransformMakeScale(365.0/348, 365.0/348)
            }
            enterButtonClickHandler?(currentIndex)
        }
    }
    
    // MARK: —— UIScrollViewDelegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.enableEnterButton(enable: true)
        })
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        enableEnterButton(enable: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / (UIScreen.main.bounds.size.width - 84))
    }
    
    // MARK: —— Private method
    private func layoutUserInterface() {
        let alpahBackgroundView = UIView.init()
        alpahBackgroundView.alpha = 0.8
        alpahBackgroundView.backgroundColor = .black
        addSubview(alpahBackgroundView)
        alpahBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let backButton:UIButton = UIButton.init(type: .system)
        backButton.setImage(UIImage(named: "guide_back_arrow_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalTo(snp.topMargin).offset(10)
            make.left.equalTo(snp.left).offset(12)
        }
        
        identityScrollView.delegate = self
        addSubview(identityScrollView)
        identityScrollView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(42)
            make.right.equalToSuperview().offset(-42)
            make.height.equalTo(365)
            make.centerY.equalToSuperview()
        }
        
        addSubview(topGradientView)
        topGradientView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(identityScrollView.snp.top).offset(-62)
        }
        
        addSubview(topLineImageView)
        topLineImageView.snp.makeConstraints { make in
            make.edges.equalTo(topGradientView)
        }
        
        addSubview(personalityLabel)
        personalityLabel.snp.makeConstraints { make in
            make.edges.equalTo(topGradientView)
        }
        
        enterButton.addTarget(self, action: #selector(enterButtonClick), for: .touchUpInside)
        addSubview(enterButton)
        enterButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(247)
            make.top.equalTo(identityScrollView.snp.bottom).offset(54)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    // Enter 按钮点击触发进度条动画
    private func excuteLayerAnimation(for button:UIButton) {
        if button.layer.sublayers != nil {
            for layer in button.layer.sublayers! {
                if layer.value(forKey: "key") != nil {
                    layer.removeFromSuperlayer()
                }
            }
        }
        let animateLayer = CAGradientLayer.init()
        animateLayer.setValue("animateLayer", forKey: "key")
        animateLayer.anchorPoint = CGPointZero
        animateLayer.colors = [UIColor(hex6: 0xBAD1FF, alpha: 0).cgColor,UIColor(hex6: 0xBAD1FF).cgColor]
        animateLayer.startPoint = CGPointZero
        animateLayer.endPoint = CGPoint(x: 1, y: 0)
        animateLayer.frame = button.bounds
        button.layer.insertSublayer(animateLayer, at: 1)
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.fromValue = NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 0, height: button.bounds.size.height))
        animation.toValue = NSValue.init(cgRect: CGRect(origin: CGPointZero, size: button.bounds.size))
        animation.fillMode = .forwards
        animateLayer.add(animation, forKey: nil)
    }
    
    private func enableEnterButton(enable:Bool) {
        enterButton.isEnabled = enable
        enterButton.alpha = enable ? 1 : 0.7
    }
}
