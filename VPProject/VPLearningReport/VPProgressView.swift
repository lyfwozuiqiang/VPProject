//
//  VPProgressView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/26.
//

import UIKit

/// 禁止直接在此View上添加控件 因为设置的旋转角度是最终是旋转self.layer
class VPProgressView: UIView {

    /// 边框宽度
    var borderWidth:CGFloat = 0 {
        didSet {
            borderLayer.lineWidth = borderWidth
        }
    }
    
    /// 边框颜色
    var borderColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            if borderColors.count == 1 && borderColors.first != nil {
                borderColors.append(borderColors.first!)
            }
            borderGradientLayer.colors = borderColors
        }
    }
    
    /// 边框渐变颜色方向设置
    var borderStartPoint:CGPoint = CGPointZero {
        didSet {
            borderGradientLayer.startPoint = borderStartPoint
        }
    }
    
    var borderEndPoint:CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            borderGradientLayer.endPoint = borderEndPoint
        }
    }
    
    /// 虚线进度条宽度
    var progressWidth:CGFloat = 5 {
        didSet {
            leftProgressLayer.lineWidth = progressWidth
            rightProgressPath.lineWidth = progressWidth
        }
    }
    
    /// 虚线进度条左半个颜色
    var leftProgressColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            if leftProgressColors.count == 1 && leftProgressColors.first != nil {
                leftProgressColors.append(leftProgressColors.first!)
            }
            leftGradientLayer.colors = leftProgressColors
        }
    }
    
    /// 虚线进度条右半个颜色
    var rightProgressColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            if rightProgressColors.count == 1 && rightProgressColors.first != nil {
                rightProgressColors.append(rightProgressColors.first!)
            }
            rightGradientLayer.colors = rightProgressColors
        }
    }
    
    /// 虚线进度条旋转角度 最终是旋转self.layer
    var rotation:CGFloat = 0 {
        didSet {
            layer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
        }
    }
    
    private let borderPath:UIBezierPath = UIBezierPath.init()
    private let borderLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.lineWidth = 0
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    private let borderGradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [UIColor.clear.cgColor]
        return gradientLayer
    }()
    
    private let leftProgressPath:UIBezierPath = UIBezierPath.init()
    private let leftProgressLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.lineWidth = 5
        shapeLayer.lineDashPattern = [10.0,2.0,10.0,2.0]
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    private let leftGradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer.init()
        layer.startPoint = CGPointZero
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()
    
    private let rightProgressPath:UIBezierPath = UIBezierPath.init()
    private let rightProgressLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.lineWidth = 5
        shapeLayer.lineDashPattern = [10.0,2.0,10.0,2.0]
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    private let rightGradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer.init()
        layer.startPoint = CGPointZero
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()
    
    //MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(borderGradientLayer)
        layer.addSublayer(leftGradientLayer)
        layer.addSublayer(rightGradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth = bounds.size.width
        borderPath.removeAllPoints()
        borderPath.addArc(withCenter: CGPoint(x: viewWidth/2, y: viewWidth/2), radius: viewWidth/2, startAngle: 0, endAngle: CGFloat(Float.pi) * 2, clockwise: true)
        borderLayer.path = borderPath.cgPath
        borderGradientLayer.frame = bounds
        borderGradientLayer.mask = borderLayer
        
        leftProgressPath.removeAllPoints()
        leftProgressPath.addArc(withCenter: CGPoint(x: viewWidth/2, y: viewWidth/2), radius: viewWidth/2 - borderWidth/2 - 3 - progressWidth/2, startAngle: CGFloat(Float.pi)/2, endAngle: CGFloat(Float.pi)/2*3, clockwise: true)
        leftProgressLayer.path = leftProgressPath.cgPath
        leftGradientLayer.frame = CGRect(x: 0, y: 0, width: viewWidth/2, height: viewWidth)
        leftGradientLayer.mask = leftProgressLayer

        rightProgressPath.removeAllPoints()
        rightProgressPath.addArc(withCenter: CGPoint(x: viewWidth/2, y: viewWidth/2), radius: viewWidth/2 - borderWidth/2 - 3 - progressWidth/2, startAngle: -CGFloat(Float.pi)/2, endAngle: CGFloat(Float.pi)/2, clockwise: true)
        rightProgressLayer.path = rightProgressPath.cgPath
        rightGradientLayer.frame = CGRect(x: viewWidth/2, y: 0, width: viewWidth, height: viewWidth)
        rightGradientLayer.mask = rightProgressLayer
        rightGradientLayer.transform = CATransform3DMakeTranslation(-viewWidth/2, 0, 0.01)
        layer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
    }
}
