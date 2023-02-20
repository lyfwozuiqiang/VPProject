//
//  VPBorderLabel.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/17.
//

import UIKit

class VPBorderLabel: UILabel {

    private let kRectangleLength = 50.0
    
    /// 是否显示边框，默认false
    public var isShowBorder = false {
        didSet {
            updateBorder()
        }
    }
    
    /// 自定义描边框宽度，默认宽度0，重写了Setter方法，会立即更新设置的宽度
    var borderWidth:Double = 0 {
        didSet {
            borderShapeLayer.lineWidth = borderWidth
        }
    }
    
    /// 自定义描边框颜色，默认无色，重写了Setter方法，会立即更新设置的颜色
    var borderColor:UIColor = .clear {
        didSet {
            borderShapeLayer.strokeColor = borderColor.cgColor
        }
    }
    
    private let borderBezierPath:UIBezierPath = UIBezierPath.init()
    private let borderShapeLayer:CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.lineCap = .round
        return layer
    }()
    
    //MARK: —— View life cycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineBreakMode = .byCharWrapping
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }
    
    //MARK: —— Public method
    ///更新贝塞尔曲线视图
    func updateBorder() {
        if isShowBorder {
            borderBezierPath.removeAllPoints()
            addBezierPathOriginPoints()
            //计算贝塞尔曲线仿射变换数据
            let rectangleWidth = bounds.size.width,rectangleHeight = bounds.size.height
            let scaleX = rectangleWidth/kRectangleLength * 0.9
            let scaleY = rectangleHeight/kRectangleLength
            //当前控件尺寸与默认矩形尺寸比例
            let scaleTransform = CGAffineTransformMakeScale(scaleX, scaleY)
            //合并尺寸比例变换与旋转角度变换
            let contatTransform = CGAffineTransformConcat(scaleTransform, CGAffineTransformMakeRotation(-0.01))
            borderBezierPath.apply(contatTransform)
            //绘制贝塞尔曲线
            borderShapeLayer.path = borderBezierPath.cgPath
            borderShapeLayer.lineWidth = borderWidth
            borderShapeLayer.fillColor = UIColor.clear.cgColor
            borderShapeLayer.strokeColor = borderColor.cgColor
            layer.addSublayer(borderShapeLayer)
        } else {
            hideBorder()
        }
    }
    
    //MARK: —— Private method
    //隐藏边框
    private func hideBorder() {
        borderShapeLayer.removeFromSuperlayer()
    }
    
    //原始贝塞尔曲线路径
    func addBezierPathOriginPoints() {
        borderBezierPath.move(to: CGPoint(x: 46, y: 46))
        let radius = sqrt(pow(kRectangleLength, 2) * 2)/2
        borderBezierPath.addQuadCurve(to: CGPointMake(kRectangleLength/2, kRectangleLength/2 + radius), controlPoint: CGPointMake(kRectangleLength/3*2, kRectangleLength/2 + radius))
        borderBezierPath.addArc(withCenter: CGPointMake(kRectangleLength/2, kRectangleLength/2), radius: radius, startAngle: .pi/2, endAngle: 0.3 * .pi, clockwise: true)
        let currentPoint = borderBezierPath.currentPoint
        borderBezierPath.addQuadCurve(to: CGPointMake(kRectangleLength/2, currentPoint.y), controlPoint: CGPointMake(kRectangleLength/4*3, kRectangleLength/2 + radius))
    }
}
