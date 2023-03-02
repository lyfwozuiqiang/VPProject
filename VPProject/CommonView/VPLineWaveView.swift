//
//  VPLineWaveView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/20.
//

import UIKit

import UIColor_Hex_Swift

class VPLineWaveView: UIView {

    /// 波纹振幅
    public var amplitude:Double = 0 {
        didSet {
            let selfWidth = bounds.size.width, selfHeight = bounds.size.height
            let line1AnimatePath = UIBezierPath.init()
            line1ControlPoint1.y = selfHeight/2 - amplitude
            line1ControlPoint2.y = selfHeight/2 + amplitude
            line1AnimatePath.move(to: CGPoint(x: 10, y: selfHeight/2))
            line1AnimatePath.addCurve(to: CGPoint(x: selfWidth - 10, y: selfHeight/2), controlPoint1: line1ControlPoint1, controlPoint2: line1ControlPoint2)
            line1ShapeLayer.path = line1AnimatePath.cgPath
            pathAnimation.fromValue = line1Path.cgPath
            pathAnimation.toValue = line1AnimatePath.cgPath
            line1ShapeLayer.add(pathAnimation, forKey: nil)
            line1Path = line1AnimatePath
            
            let line2AnimatePath = UIBezierPath.init()
            line2ControlPoint1.y = selfHeight/2 - amplitude/3
            line2ControlPoint2.y = selfHeight/2 + amplitude/3
            line2AnimatePath.move(to: CGPoint(x: -20, y: selfHeight/2))
            line2AnimatePath.addCurve(to: CGPoint(x: selfWidth + 20, y: selfHeight/2), controlPoint1: line2ControlPoint1, controlPoint2: line2ControlPoint2)
            line2ShapeLayer.path = line2AnimatePath.cgPath
            pathAnimation.fromValue = line2Path
            pathAnimation.toValue = line2AnimatePath
            line2ShapeLayer.removeAllAnimations()
            line2GradientLayer.add(pathAnimation, forKey: nil)
            line2Path = line2AnimatePath

            let line3AnimatePath = UIBezierPath.init()
            line3ControlPoint1.y = selfHeight/2 + amplitude
            line3ControlPoint2.y = selfHeight/2 - amplitude
            line3AnimatePath.move(to: CGPoint(x: -40, y: selfHeight/2))
            line3AnimatePath.addCurve(to: CGPoint(x: selfWidth + 40, y: selfHeight/2), controlPoint1: line3ControlPoint1, controlPoint2: line3ControlPoint2)
            line3ShapeLayer.path = line3AnimatePath.cgPath
            pathAnimation.fromValue = line3Path
            pathAnimation.toValue = line3AnimatePath
            line3ShapeLayer.removeAllAnimations()
            line3GradientLayer.add(pathAnimation, forKey: nil)
            line3Path = line3AnimatePath
        }
    }
  
    // 用来记录偏移的距离
    private var line1ControlPoint1 = CGPoint(x: 0, y: 0)
    private var line1ControlPoint2 = CGPoint(x: 0, y: 0)
    private var line1Path:UIBezierPath = UIBezierPath.init()
    private let line1ShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    private let line1GradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor.init(hex6: 0xF54EF9, alpha: 0).cgColor,UIColor.init(hex6: 0xF54EF9).cgColor,UIColor.init(hex6: 0x6631FF).cgColor,UIColor.init(hex6: 0x6631FF,alpha: 0).cgColor]
        return gradientLayer
    }()
    
    private var line2ControlPoint1 = CGPoint(x: 0, y: 0)
    private var line2ControlPoint2 = CGPoint(x: 0, y: 0)
    private var line2Path:UIBezierPath = UIBezierPath.init()
    private let line2ShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    private let line2GradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor.init(hex6: 0xF54EF9, alpha: 0).cgColor,UIColor.init(hex6: 0xF54EF9,alpha: 0.2).cgColor,UIColor.init(hex6: 0x6631FF, alpha: 0.2).cgColor,UIColor.init(hex6: 0x6631FF,alpha: 0).cgColor]
        return gradientLayer
    }()
    
    private var line3ControlPoint1 = CGPoint(x: 0, y: 0)
    private var line3ControlPoint2 = CGPoint(x: 0, y: 0)
    private var line3Path:UIBezierPath = UIBezierPath.init()
    private let line3ShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    private let line3GradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor.init(hex6: 0xF54EF9, alpha: 0).cgColor,UIColor.init(hex6: 0xF54EF9,alpha: 0.48).cgColor,UIColor.init(hex6: 0x6631FF, alpha: 0.48).cgColor,UIColor.init(hex6: 0x6631FF,alpha: 0).cgColor]
        return gradientLayer
    }()
    
    private let pathAnimation:CABasicAnimation = {
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.duration = 0.1
        return basicAnimation
    }()
    
    //MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        layer.addSublayer(line1GradientLayer)
        layer.addSublayer(line2GradientLayer)
        layer.addSublayer(line3GradientLayer)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let selfWidth = bounds.size.width
        line1ControlPoint1.x = selfWidth/4
        line1ControlPoint2.x = selfWidth/4*3
        line1GradientLayer.frame = bounds
        line1GradientLayer.mask = line1ShapeLayer
        
        line2ControlPoint1.x = selfWidth/4
        line2ControlPoint2.x = selfWidth/4*3
        line2GradientLayer.frame = bounds
        line2GradientLayer.mask = line2ShapeLayer
        
        line3ControlPoint1.x = selfWidth/4
        line3ControlPoint2.x = selfWidth/4*3
        line3GradientLayer.frame = bounds
        line3GradientLayer.mask = line3ShapeLayer

        lineWaveAnimation()
    }
    
    deinit {
        print("VPLineWaveView deinit")
    }
    
    //MARK: —— Action
    private func lineWaveAnimation() {
        let selfWidth = bounds.size.width, selfHeight = bounds.size.height
        //线条1运动控制
        line1ControlPoint1.y = selfHeight/2 - amplitude
        line1ControlPoint2.y = selfHeight/2 + amplitude
        line1Path.removeAllPoints()
        line1Path.move(to: CGPoint(x: 10, y: selfHeight/2))
        line1Path.addCurve(to: CGPoint(x: selfWidth - 10, y: selfHeight/2), controlPoint1: line1ControlPoint1, controlPoint2: line1ControlPoint2)
        line1ShapeLayer.path = line1Path.cgPath
        //线条2运动控制
        line2ControlPoint1.y = selfHeight/2 - amplitude/2
        line2ControlPoint2.y = selfHeight/2 + amplitude/2
        line2Path.removeAllPoints()
        line2Path.move(to: CGPoint(x: -20, y: selfHeight/2))
        line2Path.addCurve(to: CGPoint(x: selfWidth + 20, y: selfHeight/2), controlPoint1: line2ControlPoint1, controlPoint2: line2ControlPoint2)
        line2ShapeLayer.path = line2Path.cgPath
        //线条3运动控制
        line3ControlPoint1.y = selfHeight/2 + amplitude
        line3ControlPoint2.y = selfHeight/2 - amplitude
        line3Path.removeAllPoints()
        line3Path.move(to: CGPoint(x: -40, y: selfHeight/2))
        line3Path.addCurve(to: CGPoint(x: selfWidth + 40, y: selfHeight/2), controlPoint1: line3ControlPoint1, controlPoint2: line3ControlPoint2)
        line3ShapeLayer.path = line3Path.cgPath
    }
}
