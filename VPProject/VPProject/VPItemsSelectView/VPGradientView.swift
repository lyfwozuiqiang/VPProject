//
//  VPGradientView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/18.
//

import UIKit

class VPGradientView: UIView {
    
    /// 上下边线高度 默认0
    var gradientLineHeight:Double = 0 {
        didSet {
            topLineViewHeightConstraint.constant = gradientLineHeight
            bottomLineViewHeightConstraint.constant = gradientLineHeight
        }
    }
    
    /// 上下边线框渐变颜色数组 默认无色
    var topBottomLineColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            topGradientLayer.colors = topBottomLineColors
            bottomGradientLayer.colors = topBottomLineColors
        }
    }
    
    /// 背景渐变颜色数组 默认无色
    var backgroundColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            backgroundGradientLayer.colors = backgroundColors
        }
    }
    
    private let topLineViewHeightConstraint:NSLayoutConstraint
    private let bottomLineViewHeightConstraint:NSLayoutConstraint
    
    // 上边框容器
    private let topGradientView:UIView = {
        let topView = UIView.init()
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    private let topGradientLayer:CAGradientLayer = {
        let topLineLayer = CAGradientLayer.init()
        topLineLayer.startPoint = CGPoint(x: 0, y: 0)
        topLineLayer.endPoint = CGPoint(x: 1, y: 0)
        return topLineLayer
    }()
    
    private let backgroundGradientView:UIView = {
        let bgGradientView = UIView.init()
        bgGradientView.translatesAutoresizingMaskIntoConstraints = false
        return bgGradientView
    }()
    private let backgroundGradientLayer:CAGradientLayer = {
        let backGroundLayer = CAGradientLayer.init()
        backGroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backGroundLayer.endPoint = CGPoint(x: 1, y: 0)
        return backGroundLayer
    }()
    
    // 下边框容器
    private let bottomGradientView:UIView = {
        let bottomView = UIView.init()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    private let bottomGradientLayer:CAGradientLayer = {
        let bottomLineLayer = CAGradientLayer.init()
        bottomLineLayer.startPoint = CGPoint(x: 0, y: 0)
        bottomLineLayer.endPoint = CGPoint(x: 1, y: 0)
        return bottomLineLayer
    }()


    //MARK: —— View life cycle
    override init(frame: CGRect) {
        topLineViewHeightConstraint = topGradientView.heightAnchor.constraint(equalToConstant: gradientLineHeight)
        bottomLineViewHeightConstraint = bottomGradientView.heightAnchor.constraint(equalToConstant: gradientLineHeight)
        super.init(frame: frame)
        backgroundColor = .clear

        addSubview(topGradientView)
        topGradientView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topGradientView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topGradientView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLineViewHeightConstraint.isActive = true
        topGradientView.layer.addSublayer(topGradientLayer)
        
        addSubview(backgroundGradientView)
        backgroundGradientView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundGradientView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundGradientView.topAnchor.constraint(equalTo: topGradientView.bottomAnchor).isActive = true
        backgroundGradientView.layer.addSublayer(backgroundGradientLayer)
        
        addSubview(bottomGradientView)
        bottomGradientView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomGradientView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomGradientView.topAnchor.constraint(equalTo: backgroundGradientView.bottomAnchor).isActive = true
        bottomGradientView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLineViewHeightConstraint.isActive = true
        bottomGradientView.layer.addSublayer(bottomGradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topGradientLayer.frame = topGradientView.bounds
        backgroundGradientLayer.frame = backgroundGradientView.bounds
        bottomGradientLayer.frame = bottomGradientView.bounds
    }
}
