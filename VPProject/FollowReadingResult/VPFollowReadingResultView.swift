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
        label.font = UIFont.montserratRegularFont(ofSize: 16)
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
    private var animateMessageString:String = ""
    private var messageIndex:Int = 0
    private var messageWidthConstraint:NSLayoutConstraint?
    
    //MARK: —— View life cycle
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
    
    //MARK: —— Action
    @objc func displayLinkAction() {
        if titleIndex > 600 {
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
            }
        }
        
        if viewModel.message != nil && messageIndex > 0 {
            messageCharacterAnimation()
            if viewModel.message == animateMessageString {
                displayLink?.invalidate()
            }
        }
    }
    
    //MARK: —— Public method
    func excuteAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { [self] in
            titleBgViewAnimation()
            lineViewAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [self] in
                titleLabelAnimation()
            })
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
    
    
    //MARK: —— Private method
    private func titleLabelAnimation() {
        let currentFrame = titleLabel.frame
        titleLabel.frame = CGRect(x: currentFrame.origin.x + 300, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.width)
        UIView.animate(withDuration: 0.4) { [self] in
            titleLabel.isHidden = false
            titleLabel.frame = currentFrame
        }
    }
    
    private func titleBgViewAnimation() {
        let currentFrame = titleBgView.frame
        titleBgView.frame = CGRect(x: currentFrame.origin.x + 300, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.width)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) { [self] in
            titleBgView.isHidden = false
            titleBgView.frame = currentFrame
        } completion: { finished in
            if finished {
                let bgView = VPPolygonBorderView.init(frame: self.titleBgView.frame)
                bgView.backgroundColors = self.viewModel.titleBgColors ?? [UIColor.clear.cgColor]
                bgView.backgroundEndPoint = CGPoint(x: 1, y: 0)
                bgView.topSpaces = (CGPoint(x: 10, y: 0),CGPointZero)
                bgView.leftSpaces = (CGPoint(x: 10, y: 0),CGPointZero)
                bgView.bottomSpaces = (CGPointZero,CGPoint(x: 10, y: 0))
                bgView.rightSpaces = (CGPointZero,CGPoint(x: 10, y: 0))
                self.containerView.insertSubview(bgView, belowSubview: self.titleLabel)
                UIView.animate(withDuration: 0.5) {
                    bgView.transform = CGAffineTransformMakeScale(1.3, 2)
                } completion: { finished in
                    UIView.animate(withDuration: 0.3) {
                        bgView.alpha = 0
                    } completion: { finish in
                        bgView.removeFromSuperview()
                        self.messageBgViewAnimation()
                    }
                }
            }
        }
    }
    
    private func messageBgViewAnimation() {
        let currentFrame = messageBgView.frame
        messageBgView.frame = CGRect(origin: CGPoint(x: currentFrame.origin.x - 30, y: currentFrame.origin.y - 5), size: currentFrame.size)
        messageBgView.isHidden = false
        
        UIView.animate(withDuration: 0.5) { [self] in
            leftCubeView.alpha = 1
            messageBgView.isHidden = false
            messageBgView.frame = currentFrame
            messageBgView.transform = CGAffineTransformIdentity
        } completion: { [self] finished in
            messageLabel.snp.makeConstraints { make in
                make.width.equalTo(messageLabel.frame.size.width)
            }
            messageLabel.text = " "
            messageLabel.isHidden = false
            messageIndex = 1
        }
    }
    
    private func messageCharacterAnimation() {
        if animateMessageString.count < viewModel.message!.count {
            let nextCharactor  = (viewModel.message! as NSString).substring(with: NSMakeRange(animateMessageString.count, 1))
            animateMessageString.append(nextCharactor)
            let attributeStr = NSMutableAttributedString(string: animateMessageString)
            let transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/180*2))
            let fontDescriptor = UIFontDescriptor(name: "Montserrat-Regular", matrix: transform)
            let font = UIFont(descriptor: fontDescriptor, size: 16)
            attributeStr.addAttributes([.font:font,.foregroundColor:viewModel.titleColor as Any], range: NSRange(location: 0, length: attributeStr.length))
            messageLabel.attributedText = attributeStr
        }
    }
    
    private func lineViewAnimation() {
        let currentFrame = rightLineCubeView.frame
        rightLineCubeView.frame = CGRect(origin: CGPoint(x: currentFrame.origin.x + 50, y: currentFrame.origin.y), size: currentFrame.size)
        UIView.animate(withDuration: 0.4) { [self] in
            rightLineCubeView.isHidden = false
            rightLineCubeView.frame = currentFrame
        } completion: { isFinished in
            if isFinished {
                let basicAnimation = CABasicAnimation()
                basicAnimation.keyPath = "opacity"
                basicAnimation.fromValue = 0
                basicAnimation.toValue = 1
                basicAnimation.duration = 0.8
                basicAnimation.repeatCount = 1
                basicAnimation.autoreverses = true
                basicAnimation.isRemovedOnCompletion = false
                self.rightLineCubeView.layer.add(basicAnimation, forKey: nil)
            }
        }
    }
}
