//
//  VPDialogueLeftCell.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/19.
//

import UIKit

class VPDialogueLeftCell: UITableViewCell {
    
    var dialogueString:String = "" {
        didSet {
            scentenceLabel.text = dialogueString
        }
    }
    
    private let labelContentView:UIView = {
        let contentView = UIView.init()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let scentenceLabel:UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 边框视图相关
    private let borderBezierPath = UIBezierPath.init()
    private let borderShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private let borderGradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor(red: 0.96, green: 0.31, blue: 0.98, alpha: 1).cgColor,UIColor(red: 0.33, green: 0.92, blue: 1.0, alpha: 1).cgColor]
        return gradientLayer
    }()
    
    // 边框左侧一小截视图相关
    private let shortLineBezierPath = UIBezierPath.init()
    private let shortLineShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.strokeColor = UIColor(red: 0.4, green: 0.19, blue: 1.0, alpha: 1).cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    // 边框内渐变色矩形视图相关
    private let innerShapeLayer:CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    private let innerGradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer.init()
        layer.startPoint = CGPointZero
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.colors = [UIColor(red: 0.04, green: 0.04, blue: 0.1, alpha: 1).cgColor,UIColor(red: 0.04, green: 0.04, blue: 0.1, alpha: 0.6).cgColor]
        return layer
    }()
    
    // 边框宽度
    private let borderWidth:Double = 2

    //MARK: —— View lift cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(labelContentView)
        labelContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        labelContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -62).isActive = true
        labelContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(scentenceLabel)
        scentenceLabel.leadingAnchor.constraint(equalTo: labelContentView.leadingAnchor, constant: 16).isActive = true
        scentenceLabel.trailingAnchor.constraint(equalTo: labelContentView.trailingAnchor, constant: -16).isActive = true
        scentenceLabel.topAnchor.constraint(equalTo: labelContentView.topAnchor, constant: 14).isActive = true
        scentenceLabel.bottomAnchor.constraint(equalTo: labelContentView.bottomAnchor, constant: -14).isActive = true
        
        borderShapeLayer.lineWidth = borderWidth
        labelContentView.layer.addSublayer(borderShapeLayer)
        labelContentView.layer.addSublayer(borderGradientLayer)
        
        labelContentView.layer.addSublayer(innerGradientLayer)

        labelContentView.layer.addSublayer(shortLineShapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelContentViewWidth = UIScreen.main.bounds.size.width - 8 - 62;
        borderGradientLayer.frame = CGRect(x: 0, y: 0, width: labelContentViewWidth, height: contentView.bounds.size.height)
        
        borderBezierPath.removeAllPoints()
        let selfHeight = bounds.size.height
        borderBezierPath.move(to: CGPoint(x: 5 + borderWidth/2, y: borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: labelContentViewWidth - borderWidth/2, y: borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: labelContentViewWidth - 5 - borderWidth/2, y: selfHeight - borderWidth/2 - 10.0))
        borderBezierPath.addLine(to: CGPoint(x: labelContentViewWidth - 5 - borderWidth/2 - 10, y: selfHeight - borderWidth/2))
        borderBezierPath.addLine(to: CGPoint(x: borderWidth/2, y: selfHeight - borderWidth/2))
        borderBezierPath.close()
        
        borderShapeLayer.path = borderBezierPath.cgPath
        borderGradientLayer.mask = borderShapeLayer
        
        shortLineShapeLayer.lineWidth = borderWidth + 4
        shortLineBezierPath.removeAllPoints()
        shortLineBezierPath.move(to: CGPoint(x: 5 + borderWidth/2, y: borderWidth/2))
        shortLineBezierPath.addLine(to: CGPoint(x: borderWidth/2, y: selfHeight - borderWidth/2))
        let contatTransfrom = CGAffineTransformConcat(CGAffineTransform(scaleX: 1, y: (selfHeight - 20)/selfHeight), CGAffineTransformMakeTranslation(0, 10))
        shortLineBezierPath.apply(contatTransfrom)
        shortLineShapeLayer.path = shortLineBezierPath.cgPath
        
        innerGradientLayer.frame = CGRect(x: 0, y: 0, width: labelContentViewWidth, height: contentView.bounds.size.height)
        let scaleTransform = CGAffineTransform(scaleX: (labelContentViewWidth - borderWidth)/labelContentViewWidth, y: (selfHeight - borderWidth)/selfHeight)
        let innerContatTransfrom = CGAffineTransformConcat(scaleTransform, CGAffineTransformMakeTranslation(borderWidth/2, borderWidth/2))
        borderBezierPath.apply(innerContatTransfrom)
        innerShapeLayer.path = borderBezierPath.cgPath
        innerGradientLayer.mask = innerShapeLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
