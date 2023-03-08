//
//  VPPolygonBorderView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/23.
//

import UIKit

class VPPolygonBorderView: UIView {

    // 边框贝塞尔曲线
    private let borderBezierPath:UIBezierPath = UIBezierPath.init()
    // 边框图层
    private let borderShapeLayer:CAShapeLayer = CAShapeLayer.init()
    // 渐变色边框
    private let gradientLayer:CAGradientLayer = CAGradientLayer.init()
    /// 边框颜色 默认无色
    var borderColors:Array<CGColor> = [UIColor.clear.cgColor] {
        didSet {
            if borderColors.count == 1 && borderColors.first != nil {
                borderColors.append(borderColors.first!)
            }
            gradientLayer.colors = borderColors
        }
    }
    /// 边框颜色方向 默认[(0.,0),(1,1)]
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
            if backgroundColors.count == 1  && backgroundColors.first != nil {
                backgroundColors.append(backgroundColors.first!)
            }
            backgroundGradientLayer.colors = backgroundColors
        }
    }
    
    // 边框左侧一小截视图相关
    private let shortCubeBezierPath = UIBezierPath.init()
    public var shortCubeColor:CGColor = UIColor.red.cgColor {
        didSet {
            shortCubeShapeLayer.strokeColor = shortCubeColor
        }
    }
    private let shortCubeShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    /// 上方左右边距
    var topSpaces:(left:CGPoint,right:CGPoint) = (CGPointZero,CGPointZero)
    /// 左侧上下边距
    var leftSpaces:(top:CGPoint,bottom:CGPoint) = (CGPointZero,CGPointZero)
    /// 下方左右边距
    var bottomSpaces:(left:CGPoint,right:CGPoint) = (CGPointZero,CGPointZero)
    /// 右侧上下边距
    var rightSpaces:(top:CGPoint,bottom:CGPoint) = (CGPointZero,CGPointZero)
    

    // MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }
    
    // MARK: —— Private method
    func updateBorder() {
        // 描绘渐变色边框
        let viewWidth:Double = bounds.size.width, viewHeight = bounds.size.height
        borderBezierPath.removeAllPoints()
        borderBezierPath.move(to: CGPoint(x: topSpaces.left.x + borderWidth/2, y: borderWidth/2 + topSpaces.left.y))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - topSpaces.right.x - borderWidth/2, y: borderWidth/2 + topSpaces.right.y))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - borderWidth/2 - rightSpaces.top.x, y: rightSpaces.top.y + borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - borderWidth/2 - rightSpaces.bottom.x, y: viewHeight - rightSpaces.bottom.y - borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: viewWidth - bottomSpaces.right.x - borderWidth, y: viewHeight - borderWidth/2 - bottomSpaces.right.y))
        borderBezierPath.addLine(to: CGPoint(x: bottomSpaces.left.x + borderWidth/2, y: viewHeight - borderWidth/2 - bottomSpaces.left.y))
        borderBezierPath.addLine(to: CGPoint(x: borderWidth/2 + leftSpaces.bottom.x, y: viewHeight - leftSpaces.bottom.y - borderWidth))
        borderBezierPath.addLine(to: CGPoint(x: borderWidth/2 + leftSpaces.top.x, y: leftSpaces.top.y + borderWidth/2))
        borderBezierPath.close()
        
        borderShapeLayer.lineWidth = borderWidth
        borderShapeLayer.strokeColor = UIColor.green.cgColor
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
        let concatTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(borderWidth/2, borderWidth/2), CGAffineTransformMakeScale((viewWidth - borderWidth + 0.5)/viewWidth, (viewHeight - borderWidth)/viewHeight))
        borderBezierPath.apply(concatTransform)
        backgroundLayer.path = borderBezierPath.cgPath
        
        backgroundGradientLayer.frame = bounds
        backgroundGradientLayer.startPoint = backgroundStartPoint
        backgroundGradientLayer.endPoint = backgroundEndPoint
        backgroundGradientLayer.colors = backgroundColors
        backgroundGradientLayer.mask = backgroundLayer
        layer.addSublayer(backgroundGradientLayer)
        
        var cubeLineWidth:CGFloat = 0
        if borderWidth > 0 {
            cubeLineWidth = borderWidth + 4.0
        }
        shortCubeShapeLayer.lineWidth = cubeLineWidth
        shortCubeBezierPath.removeAllPoints()
        shortCubeBezierPath.move(to: CGPoint(x: leftSpaces.top.x + borderWidth/2, y: leftSpaces.top.y + borderWidth/2))
        shortCubeBezierPath.addLine(to: CGPoint(x: leftSpaces.bottom.x + borderWidth/2, y: viewHeight - leftSpaces.bottom.y - borderWidth/2))
        let contatTransfrom = CGAffineTransformConcat(CGAffineTransform(scaleX: borderWidth/2/(leftSpaces.top.x + borderWidth/2), y: 20/(viewHeight - leftSpaces.top.y - leftSpaces.bottom.y)), CGAffineTransformMakeTranslation(leftSpaces.top.x/2, (viewHeight - 20)/2))
        shortCubeBezierPath.apply(contatTransfrom)
        shortCubeShapeLayer.path = shortCubeBezierPath.cgPath
        layer.addSublayer(shortCubeShapeLayer)
    }
}
