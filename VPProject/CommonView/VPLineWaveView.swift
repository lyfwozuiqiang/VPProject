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
    public var amplitude:Double = 0
  
    // 用来记录偏移的距离
    private var line1distance:Double = 0
    // 是否反转 当偏移量超过振幅 需要进行反转
    private var isLine1Transform:Bool = false
    private var line1ControlPoint1 = CGPoint(x: 0, y: 0)
    private var line1ControlPoint2 = CGPoint(x: 0, y: 0)
    private let line1Path:UIBezierPath = UIBezierPath.init()
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
    
    private var line2distance:Double = 0
    private var isLine2Transform:Bool = false
    private var line2ControlPoint1 = CGPoint(x: 0, y: 0)
    private var line2ControlPoint2 = CGPoint(x: 0, y: 0)
    private let line2Path:UIBezierPath = UIBezierPath.init()
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
    
    private var line3distance:Double = 0
    private var isLine3Transform:Bool = true
    private var line3ControlPoint1 = CGPoint(x: 0, y: 0)
    private var line3ControlPoint2 = CGPoint(x: 0, y: 0)
    private let line3Path:UIBezierPath = UIBezierPath.init()
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
    
    private var displayLink:CADisplayLink?

    //MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        displayLink = CADisplayLink.init(target: self, selector: #selector(displayLinkAction))
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 30, __preferred: 30)
        } else {
            displayLink?.preferredFramesPerSecond = 30
        }
        displayLink?.isPaused = true
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
        layer.addSublayer(line1GradientLayer)
        
        line2distance = 20
        layer.addSublayer(line2GradientLayer)
        
        line3distance = -10
        layer.addSublayer(line3GradientLayer)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            enableWaveAnimation(enable: false)
        } else {
            enableWaveAnimation(enable: true)
        }
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
    }
    
    deinit {
        print("VPLineWaveView deinit")
    }
    
    //MARK: —— Action
    @objc private func displayLinkAction() {
        let selfWidth = bounds.size.width, selfHeight = bounds.size.height
        //线条1运动控制
        if line1distance > amplitude || line1distance < -amplitude{
            isLine1Transform = !isLine1Transform
        }
        if isLine1Transform {
            if line1distance > amplitude {
                line1distance = amplitude
            }
            line1distance += 1
        } else {
            if line1distance < -amplitude {
                line1distance = amplitude
            }
            line1distance -= 1
        }
        
        line1ControlPoint1.y = selfHeight/2 - line1distance
        line1ControlPoint2.y = selfHeight/2 + line1distance
        line1Path.removeAllPoints()
        line1Path.move(to: CGPoint(x: -10, y: selfHeight/2))
        line1Path.addCurve(to: CGPoint(x: selfWidth + 10, y: selfHeight/2), controlPoint1: line1ControlPoint1, controlPoint2: line1ControlPoint2)
        line1ShapeLayer.path = line1Path.cgPath
        
        //线条2运动控制
        if line2distance > amplitude || line2distance < -amplitude{
            isLine2Transform = !isLine2Transform
        }
        if isLine2Transform {
            if line2distance > amplitude {
                line2distance = amplitude
            }
            line2distance += 1
        } else {
            if line2distance < -amplitude {
                line2distance = amplitude
            }
            line2distance -= 1
        }
        line2ControlPoint1.y = selfHeight/2 - line2distance
        line2ControlPoint2.y = selfHeight/2 + line2distance
        line2Path.removeAllPoints()
        line2Path.move(to: CGPoint(x: -20, y: selfHeight/2))
        line2Path.addCurve(to: CGPoint(x: selfWidth + 20, y: selfHeight/2), controlPoint1: line2ControlPoint1, controlPoint2: line2ControlPoint2)
        line2ShapeLayer.path = line2Path.cgPath
        
        //线条3运动控制
        if line3distance > amplitude || line3distance < -amplitude{
            isLine3Transform = !isLine3Transform
        }
        if isLine3Transform {
            if line3distance > amplitude {
                line3distance = amplitude
            }
            line3distance += 1
        } else {
            if line3distance < -amplitude {
                line3distance = amplitude
            }
            line3distance -= 1
        }
        line3ControlPoint1.y = selfHeight/2 - line3distance
        line3ControlPoint2.y = selfHeight/2 + line3distance
        line3Path.removeAllPoints()
        line3Path.move(to: CGPoint(x: -30, y: selfHeight/2))
        line3Path.addCurve(to: CGPoint(x: selfWidth + 30, y: selfHeight/2), controlPoint1: line3ControlPoint1, controlPoint2: line3ControlPoint2)
        line3ShapeLayer.path = line3Path.cgPath
    }
    
    //MARK: —— Public method
    func enableWaveAnimation(enable:Bool) {
        displayLink?.isPaused = !enable
    }
    
    func invalidateDisplayLink() {
        displayLink?.invalidate()
    }
}
