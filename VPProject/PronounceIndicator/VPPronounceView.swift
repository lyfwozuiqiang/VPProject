//
//  VPPronounceView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/24.
//

import UIKit

struct PronounceViewModel {
    /// 气泡在左侧或者右侧
    enum PronounceViewSide {
        // 左侧 + 距离
        case left(space:Double)
        // 右侧 + 距离
        case right(space:Double)
    }
    
    // 气泡方位 会在指定点位置添加一个size为0的view，然后针对此view布局气泡
    enum PronounceViewPosition {
        // 指定点上方
        case top(CGPoint)
        // 指定点下方
        case bottom(CGPoint)
    }
    
    let containerSide:PronounceViewSide
    let containerPosition:PronounceViewPosition
    // 是否展示指示三角形,位置为PronounceViewPosition指定点位置
    let isShowTriangle:Bool
    // 美式发音
    let americanAccent:String?
    // 英式发音
    let britishAccent:String?
    // 词性
    let translateContent:Array<String>?
}

class VPPronounceView: UIView {
    
    //设置气泡颜色 也同时会设置指示三角颜色
    var viewColor:UIColor? {
        didSet {
            alphaView.backgroundColor = viewColor
            triangleShapeLayer.fillColor = viewColor?.cgColor
        }
    }
    
    var pronounceButtonClickHandler:((_ tag:NSInteger) -> Void)?
    
    private let triangleBezierPath:UIBezierPath = UIBezierPath()
    private let triangleShapeLayer:CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 0
        layer.fillColor = UIColor(hex6: 0x0B0A1A, alpha: 0.8).cgColor
        return layer
    }()
    
    private let containerView:UIView = {
        let backgroundView = UIView.init()
        backgroundView.backgroundColor = .clear
        return backgroundView
    }()
    
    private let alphaView:UIView = {
        let view = UIView.init()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(hex6: 0x0B0A1A, alpha: 0.8)
        return view
    }()
    
    private let britishPronounceLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.pingFangSCRFont(ofSize: 14)
        label.textColor = UIColor(hex6: 0xF9FAFA)
        return label
    }()
    private let britishPronounceButton:UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "announce_play_icon"), for: .normal)
        return button
    }()
    
    private let americanPronounceLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.pingFangSCRFont(ofSize: 14)
        label.textColor = UIColor(hex6: 0xF9FAFA)
        return label
    }()
    private let americanPronounceButton:UIButton = {
        let button = UIButton.init()
        button.tag = 1
        button.setImage(UIImage(named: "announce_play_icon"), for: .normal)
        return button
    }()

    //MARK: —— View life cycle
    init(with pronounceModel:PronounceViewModel) {
        super.init(frame: CGRectZero)
        
        backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTapHandle))
        addGestureRecognizer(tapGesture)
        
        addSubview(containerView)
        
        containerView.addSubview(alphaView)
        alphaView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
 
        britishPronounceLabel.text = pronounceModel.britishAccent
        americanPronounceLabel.text = pronounceModel.americanAccent
        //左右边距12 发音按钮34 英美音标间距16
        let textHalfLength:CGFloat = CGFloat(265 - 12.0 * 2 - 34.0 * 2 - 16)/2.0
        let britishAccentLength = calculateLength(text: pronounceModel.britishAccent, maxWidth: 265)
        let isBritishOverHalfWidth = britishAccentLength > textHalfLength
        let americanAccentLenth = calculateLength(text: pronounceModel.americanAccent, maxWidth: 265)
        let isAmericanOverHalfWidth:Bool = americanAccentLenth > textHalfLength
        
        containerView.addSubview(britishPronounceLabel)
        britishPronounceButton.addTarget(self, action: #selector(pronounceButtonClick), for: .touchUpInside)
        containerView.addSubview(britishPronounceButton)
        containerView.addSubview(americanPronounceLabel)
        americanPronounceButton.addTarget(self, action: #selector(pronounceButtonClick), for: .touchUpInside)
        containerView.addSubview(americanPronounceButton)
        britishPronounceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(britishPronounceButton.snp.centerY)
        }
        britishPronounceButton.isHidden = pronounceModel.britishAccent == nil
        britishPronounceButton.snp.makeConstraints { make in
            make.right.lessThanOrEqualTo(containerView.snp.right).offset(-12)
            make.size.equalTo(34)
            make.top.equalToSuperview()
            make.left.equalTo(britishPronounceLabel.snp.right)
        }
        
        americanPronounceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(americanPronounceButton.snp.centerY)
            if isBritishOverHalfWidth || isAmericanOverHalfWidth {
                make.left.equalToSuperview().offset(12)
            } else {
                make.right.equalTo(americanPronounceButton.snp.left)
            }
        }
        americanPronounceButton.isHidden = pronounceModel.americanAccent == nil
        americanPronounceButton.snp.makeConstraints { make in
            make.size.equalTo(34)
            if isBritishOverHalfWidth || isAmericanOverHalfWidth {
                make.top.equalTo(britishPronounceButton.snp.bottom).offset(-8)
                make.right.lessThanOrEqualTo(containerView.snp.right).offset(-4)
                make.left.equalTo(americanPronounceLabel.snp.right)
            } else {
                make.top.equalTo(containerView)
                make.right.equalTo(containerView.snp.right).offset(-4)
            }
        }
        
        var previousLabel:UILabel?
        for index in 0..<(pronounceModel.translateContent?.count ?? 0) {
            let itemLabel = UILabel.init()
            itemLabel.numberOfLines = 0
            itemLabel.font = UIFont.pingFangSCRFont(ofSize: 12)
            itemLabel.textColor = UIColor(hex6: 0xF9FAFA)
            itemLabel.text = pronounceModel.translateContent?[index]
            containerView.addSubview(itemLabel)
            itemLabel.snp.makeConstraints { make in
                make.left.equalTo(containerView).offset(12)
                make.right.equalTo(containerView.snp.right).offset(-12)
                if index == 0 {
                    make.top.equalTo(americanPronounceButton.snp.bottom)
                } else {
                    make.top.equalTo(previousLabel!.snp.bottom).offset(4)
                }
            }
            previousLabel = itemLabel
        }
        
        let basePoint:CGPoint
        switch pronounceModel.containerPosition {
        case .top(let point):
            basePoint = point
            if pronounceModel.isShowTriangle {
                triangleBezierPath.move(to: CGPoint(x: point.x, y: point.y + 5))
            }
        case .bottom(let point):
            basePoint = point
            if pronounceModel.isShowTriangle {
                triangleBezierPath.move(to: CGPoint(x: point.x, y: point.y - 5))
            }
        }
        if pronounceModel.isShowTriangle {
            triangleBezierPath.addLine(to: CGPoint(x: basePoint.x - 5, y: basePoint.y))
            triangleBezierPath.addLine(to: CGPoint(x: basePoint.x + 5, y: basePoint.y))
            triangleBezierPath.close()
            // 添加三角指示
            triangleShapeLayer.path = triangleBezierPath.cgPath
            layer.addSublayer(triangleShapeLayer)
        }
        
        // 参照view containerView会根据此view布局
        let view = UIView.init(frame: CGRect(x: basePoint.x, y: basePoint.y, width: 0, height: 0))
        self.addSubview(view)
        
        containerView.snp.makeConstraints { make in
            switch pronounceModel.containerSide {
            case .left(let space):
                make.left.equalToSuperview().offset(space)
            case .right(let space):
                make.trailing.equalToSuperview().offset(-space)
            }
            
            switch pronounceModel.containerPosition {
            case .top(_):
                make.bottom.equalTo(view)
            case .bottom(_):
                make.top.equalTo(view)
            }
            
            make.width.equalTo(265)
            if previousLabel == nil {
                make.bottom.equalTo(americanPronounceButton.snp.bottom).offset(4)
            } else {
                make.bottom.equalTo(previousLabel!.snp.bottom).offset(8)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    //MARK: —— Action
    @objc func viewTapHandle() {
        removeFromSuperview()
    }
    
    @objc func pronounceButtonClick(button:UIButton) {
        pronounceButtonClickHandler?(button.tag)
    }
    
    //MARK: —— Pirvate method
    private func calculateLength(text:String?, maxWidth:CGFloat) -> CGFloat {
        if text == nil {
            return 0.0
        }
        let textSize:CGSize = (text! as NSString).boundingRect(with: CGSize(width: maxWidth, height: 1000), attributes: [.font:UIFont.pingFangSCRFont(ofSize: 12)], context: nil).size
        return textSize.width
    }
}
