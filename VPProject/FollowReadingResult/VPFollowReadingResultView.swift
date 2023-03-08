//
//  VPFollowReadingResultView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/28.
//

import UIKit

struct FollowReadingViewModel {
    /// 上排文字
    let title:String?
    /// 下排文字
    let message:String?
    /// 上排文字颜色
    let titleColor:UIColor?
    /// 下排文字颜色
    let messageColor:UIColor?
    /// 左侧方块颜色
    let lefCubeColors:[CGColor]?
    /// 上排文字背景View颜色
    let titleBgColors:[CGColor]?
    /// 下排文字背景View颜色
    let messageBgColor:[CGColor]
}

class VPFollowReadingResultView: UIView {
    
    private let viewModel:FollowReadingViewModel
    
    private let containerView = UIView.init()
    private let titleBgView:VPPolygonBorderView = {
        let view = VPPolygonBorderView.init()
        view.isHidden = true
        view.backgroundEndPoint = CGPoint(x: 1, y: 0)
        view.topSpaces = (CGPoint(x: 10, y: 0),CGPointZero)
        view.leftSpaces = (CGPoint(x: 10, y: 0),CGPointZero)
        view.bottomSpaces = (CGPointZero,CGPoint(x: 10, y: 0))
        view.rightSpaces = (CGPointZero,CGPoint(x: 10, y: 0))
        return view
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel.init()
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel:UILabel = {
        let label = UILabel.init()
        label.isHidden = true
        label.font = UIFont.montserratSemiBoldItalicFont(ofSize: 16)
        return label
    }()
    private let messageBgView:VPPolygonBorderView = {
        let view = VPPolygonBorderView.init()
        view.isHidden = true
        view.backgroundEndPoint = CGPoint(x: 1, y: 0)
        view.topSpaces = (CGPoint(x: 15, y: 0),CGPointZero)
        view.leftSpaces = (CGPoint(x: 15, y: 0),CGPointZero)
        view.bottomSpaces = (CGPointZero,CGPoint(x: 10, y: 0))
        view.rightSpaces = (CGPointZero,CGPoint(x: 10, y: 0))
        return view
    }()
    
    private let leftCubeView:VPPolygonBorderView = {
        let view = VPPolygonBorderView.init()
        view.alpha = 0
        view.backgroundEndPoint = CGPoint(x: 1, y: 0)
        view.topSpaces = (CGPoint(x: 5, y: 0),CGPointZero)
        view.leftSpaces = (CGPoint(x: 5, y: 0),CGPointZero)
        view.bottomSpaces = (CGPointZero,CGPoint(x: 5, y: 0))
        view.rightSpaces = (CGPointZero,CGPoint(x: 5, y: 0))
        return view
    }()
    
    private let rightLineCubeView:VPPolygonBorderView = {
        let view = VPPolygonBorderView.init()
        view.isHidden = true
        view.backgroundEndPoint = CGPoint(x: 1, y: 0)
        view.topSpaces = (CGPoint(x: 5, y: 0),CGPointZero)
        view.leftSpaces = (CGPoint(x: 5, y: 0),CGPointZero)
        view.bottomSpaces = (CGPointZero,CGPoint(x: 5, y: 0))
        view.rightSpaces = (CGPointZero,CGPoint(x: 5, y: 0))
        view.backgroundColors = [UIColor(hex6: 0xF54EF9).cgColor,UIColor(hex6: 0xF54EF9, alpha:0).cgColor]
        return view
    }()
    
    private var displayLink:CADisplayLink?
    private var animateTitleString:String = ""
    private var titleIndex:Int = 0
    
    // MARK: —— View life cycle
    init(with model:FollowReadingViewModel) {
        viewModel = model
        super.init(frame: CGRectZero)
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        containerView.addSubview(messageBgView)
        containerView.addSubview(leftCubeView)
        containerView.addSubview(messageLabel)
        
        messageBgView.backgroundColors = model.messageBgColor
        messageBgView.snp.makeConstraints { make in
            make.left.equalTo(messageLabel.snp.left).offset(-15)
            make.right.equalTo(containerView.snp.right)
            make.top.equalTo(messageLabel.snp.top)
            make.bottom.equalTo(messageLabel.snp.bottom)
        }
        
        leftCubeView.backgroundColors = model.lefCubeColors ?? [UIColor.clear.cgColor]
        leftCubeView.snp.makeConstraints { make in
            make.right.equalTo(messageLabel.snp.left).offset(4)
            make.centerY.equalTo(messageLabel.snp.centerY)
            make.width.equalTo(28)
            make.height.equalTo(6)
        }
        
        messageLabel.text = model.message
        messageLabel.textColor = model.messageColor
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(containerView.snp.centerX).offset(20)
            make.bottom.equalTo(containerView.snp.bottom)
            make.right.equalTo(messageBgView.snp.right).offset(-10)
        }
        
        containerView.addSubview(titleBgView)
        titleBgView.backgroundColors = model.titleBgColors ?? [UIColor.clear.cgColor]
        titleBgView.snp.makeConstraints { make in
            make.left.equalTo(containerView.snp.left)
            make.bottom.equalTo(messageBgView.snp.top).offset(-4)
            make.height.equalTo(12)
            make.width.equalTo(114)
        }
        
        containerView.addSubview(rightLineCubeView)
        rightLineCubeView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(48)
            make.right.equalTo(messageBgView.snp.right)
            make.bottom.equalTo(messageBgView.snp.top)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.top.equalTo(containerView.snp.top)
            make.left.equalTo(titleBgView.snp.left).offset(15)
            make.bottom.equalTo(titleBgView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("VPFollowReadingResultViewdeinit")
    }
    
    // MARK: —— Action
    @objc func displayLinkAction() {
        if titleIndex > 300 {
            displayLink?.invalidate()
        }
        titleIndex += 1
        if viewModel.title != nil {
            if titleIndex % 2 == 0 && titleIndex > 30 && animateTitleString.count < viewModel.title!.count {
                let nextCharactor  = (viewModel.title! as NSString).substring(with: NSMakeRange(animateTitleString.count, 1))
                animateTitleString.append(nextCharactor)
                let textAttributeStr = NSMutableAttributedString(string: animateTitleString)
                let strShadow = NSShadow()
                strShadow.shadowOffset = CGSize(width: 1, height: 1)
                strShadow.shadowColor = viewModel.titleColor?.withAlphaComponent(0.4)
                let transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/180*2))
                let fontDescriptor = UIFontDescriptor(name: "Russo One", matrix: transform)
                let font = UIFont(descriptor: fontDescriptor, size: 28)
                textAttributeStr.addAttributes([.font:font,.shadow:strShadow,.foregroundColor:viewModel.titleColor as Any], range: NSRange(location: 0, length: textAttributeStr.length))
                titleLabel.attributedText = textAttributeStr
                if animateTitleString.count == viewModel.title?.count {
                    displayLink?.invalidate()
                }
            }
        }
    }
    
    // MARK: —— Public method
    func excuteAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [self] in
            titleAnimation()
            messageAnimation()
            lineViewAnimation()
        })
        
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction))
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
        } else {
            displayLink?.preferredFramesPerSecond = 60
        }
        displayLink?.add(to: .current, forMode: .common)
    }
    
    
    // MARK: —— Private method
    private func titleAnimation() {
        let titleLabelFrame = titleLabel.frame
        titleLabel.frame = CGRect(origin: CGPoint(x: titleLabelFrame.origin.x + 300, y: titleLabelFrame.origin.y), size: titleLabelFrame.size)
        
        let titleBgFrame = titleBgView.frame
        titleBgView.frame = CGRect(origin: CGPoint(x: titleBgFrame.origin.x + 300, y: titleBgFrame.origin.y), size: titleBgFrame.size)
        
        UIView.animate(withDuration: 0.4) { [self] in
            titleLabel.isHidden = false
            titleLabel.frame = titleLabelFrame
            titleBgView.isHidden = false
            titleBgView.frame = titleBgFrame
        }
    }
    
    private func messageAnimation() {
        let messageBgFrame = messageBgView.frame
        messageBgView.frame = CGRect(origin: CGPoint(x: messageBgFrame.origin.x + 300, y: messageBgFrame.origin.y), size: messageBgFrame.size)
        
        let messageLabelFrame = messageLabel.frame
        messageLabel.frame = CGRect(origin: CGPoint(x: messageLabelFrame.origin.x + 300, y: messageLabelFrame.origin.y), size: messageLabelFrame.size)
        
        let cubeFrame = leftCubeView.frame
        leftCubeView.frame = CGRect(origin: CGPoint(x: cubeFrame.origin.x + 300, y: cubeFrame.origin.y), size: cubeFrame.size)
        
        UIView.animate(withDuration: 0.4, delay:0.2) { [self] in
            leftCubeView.alpha = 1
            leftCubeView.frame = cubeFrame
            messageBgView.isHidden = false
            messageBgView.frame = messageBgFrame
        }
        
        UIView.animate(withDuration: 0.4, delay:0.4) { [self] in
            messageLabel.isHidden = false
            messageLabel.frame = messageLabelFrame
        }
    }
    
    private func lineViewAnimation() {
        let currentFrame = rightLineCubeView.frame
        rightLineCubeView.frame = CGRect(origin: CGPoint(x: currentFrame.origin.x + 50, y: currentFrame.origin.y), size: currentFrame.size)
        UIView.animate(withDuration: 0.4) { [self] in
            rightLineCubeView.isHidden = false
            rightLineCubeView.frame = currentFrame
        }
    }
}
