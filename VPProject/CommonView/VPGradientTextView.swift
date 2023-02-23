//
//  VPGradientTextLabel.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/22.
//

import UIKit

class VPGradientTextView: UIView {
    
    var text:String? {
        didSet {
            textLabel.text = text
        }
    }
    
    /// 默认系统字体
    var font:UIFont? {
        didSet {
            textLabel.font = font
        }
    }
    
    var startPoint:CGPoint = CGPointZero {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }
    
    var endPoint:CGPoint = CGPoint(x: 1, y: 0) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }
    
    // 如果只设置一个颜色 会显示为无色 所以当设置一种颜色时默认为显示纯色
    var colors:Array<CGColor> = [UIColor.white.cgColor,UIColor.white.cgColor] {
        didSet {
            if colors.count == 1 {
                colors.append(colors.first ?? UIColor.white.cgColor)
            }
            gradientLayer.colors = colors
        }
    }
    
    private let textLabel:UILabel = UILabel.init()

    private let gradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer.init()
        layer.startPoint = CGPoint.zero
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.colors = [UIColor.white.cgColor,UIColor.white.cgColor]
        return layer
    }()
    
    //MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel.textAlignment = .center
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    //MARK: —— Private method
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.bounds
        gradientLayer.mask = textLabel.layer
    }
    
}
