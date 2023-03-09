//
//  VPToastView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/8.
//

import UIKit

class VPToastView: UIView {
    
    class func show(message:String, in view:UIView, iconName:String? = nil, duration:CGFloat = 1.5) {
        let toastView = VPToastView.init(with: message, iconName: iconName, duration: duration)
        view.addSubview(toastView)
        toastView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    init(with message:String, iconName:String? = nil, duration:CGFloat = 1.5) {
        super.init(frame: CGRectZero)
        
        alpha = 0
        backgroundColor = .clear
        
        let containerView = VPPolygonBorderView.init()
        addSubview(containerView)
        containerView.backgroundEndPoint = CGPoint(x: 0, y: 1)
        containerView.backgroundColors = [UIColor(hex6: 0xA790FF).cgColor,UIColor(hex6: 0x806BFF, alpha: 0.72).cgColor]
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 0.5
        containerView.layer.masksToBounds = true
        containerView.layer.borderColor = UIColor(hex6: 0xD3C8FF).cgColor
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        
        var imageView:UIImageView?
        if iconName != nil {
            imageView = UIImageView.init()
            imageView?.contentMode = .scaleAspectFit
            imageView?.image = UIImage(named: iconName!)
            addSubview(imageView!)
            imageView?.snp.makeConstraints { make in
                make.top.equalTo(containerView.snp.top).offset(16)
                make.size.equalTo(48)
                make.centerX.equalToSuperview()
            }
        }
        
        let messageLabel = UILabel.init()
        messageLabel.font = UIFont.montserratRegularFont(ofSize: 16)
        messageLabel.text = message
        messageLabel.numberOfLines = 2
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            if imageView != nil {
                make.top.equalTo(imageView!.snp.bottom).offset(8)
            } else {
                make.top.equalTo(containerView.snp.top).offset(18)
            }
            make.width.lessThanOrEqualTo(200)
            make.left.equalTo(containerView.snp.left).offset(20)
            make.right.equalTo(containerView.snp.right).offset(-20)
            make.bottom.equalTo(containerView.snp.bottom).offset(-18)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
