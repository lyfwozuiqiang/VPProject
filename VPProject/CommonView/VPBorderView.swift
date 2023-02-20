//
//  VPBorderView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/17.
//

import UIKit

class VPBorderView: UIView {
    
    // 边框贝塞尔曲线
    private let borderBezierPath:UIBezierPath = UIBezierPath.init()
    // 边框图层
    private let borderShapeLayer:CAShapeLayer = CAShapeLayer.init()
    // 渐变色边框
    private let gradientLayer:CAGradientLayer = CAGradientLayer.init()
    /// 边框颜色 默认无色
    var borderColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            gradientLayer.colors = borderColors
        }
    }
    
    var borderStartPoint:CGPoint = CGPointZero {
        didSet {
            gradientLayer.startPoint = borderStartPoint
        }
    }
    
    var borderEndPoint:CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            gradientLayer.endPoint = borderEndPoint
        }
    }
    
    /// 边框宽度 默认0
    var borderWidth:Double = 0 {
        didSet {
            borderShapeLayer.lineWidth = borderWidth
        }
    }
    
    // 背景图层
    var backgroundStartPoint:CGPoint = CGPointZero {
        didSet {
            backgroundGradientLayer.startPoint = backgroundStartPoint
        }
    }
    
    var backgroundEndPoint:CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            backgroundGradientLayer.endPoint = backgroundEndPoint
        }
    }
    private let backgroundLayer:CAShapeLayer = CAShapeLayer.init()
    private let backgroundGradientLayer:CAGradientLayer = CAGradientLayer.init()
    /// 不规则背景形状景颜色 渐变色需要至少2个颜色 所以当设置了一个颜色时认为为纯色背景
    var backgroundColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            if backgroundColors.count == 1 {
                let color:CGColor = backgroundColors.first!
                backgroundColors.append(color)
                backgroundGradientLayer.colors = backgroundColors
            }
        }
    }
    
    /// 上方左右边距
    var topSpacess:(left:Double,right:Double) = (0,0)
    /// 左侧上下边距
    var leftSpaces:(top:Double,bottom:Double) = (0,0)
    /// 下方左右边距
    var bottomSpaces:(left:Double,right:Double) = (0,0)
    /// 右侧上下边距
    var rightSpaces:(top:Double,bottom:Double) = (0,0)

    //MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 描绘渐变色边框
        let viewWidth:Double = bounds.size.width, viewHeight = bounds.size.height
        borderBezierPath.removeAllPoints()
        borderBezierPath.move(to: CGPoint(x: topSpacess.left + borderWidth/2, y: borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - topSpacess.right - borderWidth/2, y: borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - borderWidth, y: rightSpaces.top + borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - borderWidth, y: viewHeight - rightSpaces.bottom - borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - bottomSpaces.right - borderWidth, y: viewHeight - borderWidth))
        borderBezierPath.addLine(to: CGPoint(x: bottomSpaces.left - borderWidth/2, y: viewHeight - borderWidth))
        borderBezierPath.addLine(to: CGPoint(x: borderWidth/2, y: viewHeight - leftSpaces.bottom - borderWidth))
        borderBezierPath.addLine(to: CGPoint(x: borderWidth/2, y: leftSpaces.top + borderWidth/2))
        borderBezierPath.close()
        
        borderShapeLayer.lineWidth = borderWidth
        borderShapeLayer.strokeColor = UIColor.white.cgColor
        borderShapeLayer.fillColor = UIColor.clear.cgColor
        borderShapeLayer.path = borderBezierPath.cgPath
        
        gradientLayer.frame = bounds
        gradientLayer.startPoint = borderStartPoint
        gradientLayer.endPoint = borderEndPoint
        gradientLayer.colors = borderColors
        gradientLayer.mask = borderShapeLayer
        layer.addSublayer(gradientLayer)
        
        // 绘制不规则形状背景
        backgroundLayer.strokeColor = UIColor.clear.cgColor
        backgroundLayer.fillColor = UIColor.white.cgColor
        let concatTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(borderWidth/2, borderWidth/2), CGAffineTransformMakeScale((viewWidth - borderWidth)/viewWidth, (viewHeight - borderWidth)/viewHeight))
        borderBezierPath.apply(concatTransform)
        backgroundLayer.path = borderBezierPath.cgPath
        layer.addSublayer(backgroundLayer)
        
        backgroundGradientLayer.frame = bounds
        backgroundGradientLayer.startPoint = backgroundStartPoint
        backgroundGradientLayer.endPoint = backgroundEndPoint
        backgroundGradientLayer.colors = backgroundColors
        backgroundGradientLayer.mask = backgroundLayer
        layer.addSublayer(backgroundGradientLayer)
    }
}
