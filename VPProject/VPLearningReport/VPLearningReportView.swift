//
//  VPLearningReportView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/25.
//

import UIKit

class VPLearningReportView: UIView {
    
    var quitHandler:(() -> Void)?
    var shareHandler:(() -> Void)?
    
    private let backgroundImageView:UIImageView = {
        let imageView = UIImageView.init(image: UIImage(named: "learn_report_background_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer.init()
        layer.startPoint = CGPointZero
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.colors = [UIColor(hex6: 0x0C0B22).cgColor,UIColor(hex6: 0x140428).cgColor,UIColor(hex6: 0x140428).cgColor]
        return layer
    }()

    private let reportScrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let quitButton:UIButton = {
        let button = UIButton.init(type: .system)
        let quitIcon = UIImage(named: "learn_report_quit_button_icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(quitIcon, for: .normal)
        button.setTitle("Quit", for: .normal)
        button.setTitleColor(UIColor(hex6: 0xFFFFFF), for: .normal)
        button.titleLabel?.font = UIFont.montserratRegularFont(ofSize: 16)
        return button
    }()
    
    private let reportBgView:VPPolygonBorderView = {
        let view = VPPolygonBorderView.init()
        view.borderWidth = 1
        view.borderColors = [UIColor(hex6: 0x55EBFF).cgColor,UIColor(hex6: 0x6631FF).cgColor,UIColor(hex6: 0x4EEFF9).cgColor]
        view.borderEndPoint = CGPoint(x: 1, y: 0)
        view.backgroundColors = [UIColor(hex6: 0x9883EA).cgColor,UIColor(hex6: 0x4335FF).cgColor,UIColor(hex6: 0x0E050B).cgColor]
        view.backgroundEndPoint = CGPoint(x: 1, y: 0)
        view.leftSpaces = (CGPoint(x: 5, y: 15),CGPointZero)
        view.topSpaces = (CGPoint(x: 15, y: 0),CGPointZero)
        view.shortCubeColor = UIColor(hex6: 0x55EBFF).cgColor
        return view
    }()
    
    private let reportTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Daily Report……"
        label.textColor = .white
        label.font = UIFont.russoOneFont(ofSize: 20)
        return label
    }()
    
    private let reportCoinLabel:VPGradientTextView = {
        let textView = VPGradientTextView()
        textView.text = "T-coin:"
        textView.colors = [UIColor(hex6: 0x55EBFF).cgColor,UIColor(hex6: 0x6DC2FF).cgColor]
        textView.font = UIFont.russoOneFont(ofSize: 12)
        return textView
    }()
    
    private let coinImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "learn_report_coin_icon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let coinCountLabel:VPGradientTextView = {
        let textView = VPGradientTextView()
        textView.colors = [UIColor(hex6: 0x55EBFF).cgColor,UIColor(hex6: 0x6DC2FF).cgColor]
        textView.font = UIFont.russoOneFont(ofSize: 12)
        return textView
    }()
    
    private let dragonImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "learn_report_dragon_icon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let cubeImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "learn_report_cube_icon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let onBoardingLabel:UILabel = {
        let label = UILabel()
        label.text = "ON  Boarding"
        label.textColor = .white
        label.font = UIFont.russoOneFont(ofSize: 16)
        return label
    }()
    
    private let dayLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.russoOneFont(ofSize: 16)
        return label
    }()
    
    private let lineGradientView:VPGradientView = {
        let view = VPGradientView.init()
        view.backgroundColors = [UIColor(hex6: 0x6631FF, alpha: 0).cgColor,UIColor(hex6: 0x6FD0FF).cgColor,UIColor(hex6: 0xF54EF9, alpha: 0).cgColor]
        return view
    }()
    
    private let timeImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "learn_report_time_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let pronounceImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "learn_report_pronounce_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let fluenceImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "learn_report_fluency_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let timeProgressView:VPProgressView = {
        let view = VPProgressView.init()
        view.borderWidth = 1
        view.rotation = CGFloat(-Float.pi/180*45)
        view.borderColors = [UIColor(hex6: 0x006B8D).cgColor]
        view.leftProgressColors = [UIColor(hex6: 0x84FFF0,alpha: 0).cgColor,UIColor(hex6: 0x84FFF0,alpha: 0.5).cgColor]
        view.rightProgressColors = [UIColor(hex6: 0x84FFF0).cgColor,UIColor(hex6: 0x84FFF0,alpha: 0.5).cgColor]
        return view
    }()
    
    private let pronounceProgressView:VPProgressView = {
        let view = VPProgressView.init()
        view.borderWidth = 1
        view.rotation = CGFloat(-Float.pi/180*45)
        view.borderColors = [UIColor(hex6: 0x006B8D).cgColor]
        view.leftProgressColors = [UIColor(hex6: 0xED7CFF,alpha: 0).cgColor,UIColor(hex6: 0xED7CFF,alpha: 0.5).cgColor]
        view.rightProgressColors = [UIColor(hex6: 0xED7CFF).cgColor,UIColor(hex6: 0xED7CFF,alpha: 0.5).cgColor]
        return view
    }()
    
    private let fluencyProgressView:VPProgressView = {
        let view = VPProgressView.init()
        view.borderWidth = 1
        view.borderColors = [UIColor(hex6: 0x006B8D).cgColor]
        view.leftProgressColors = [UIColor(hex6: 0x6733FF,alpha: 0).cgColor,UIColor(hex6: 0x6733FF).cgColor]
        view.rightProgressColors = [UIColor(hex6: 0x6733FF).cgColor,UIColor(hex6: 0x6733FF).cgColor]
        return view
    }()
    
    private let timeDesLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let pronounceDesLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let fluencyDesLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let conclutionImageView:UIImageView = {
        let imageView = UIImageView.init()
        var image = UIImage(named: "learn_report_conclusion_bg_image")
        image = image?.stretchableImage(withLeftCapWidth: Int((image?.size.width)!/2), topCapHeight: Int((image?.size.height)!)/2)
        imageView.image = image
        return imageView
    }()
    
    private let greatImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "learn_report_blue_icon")
        return imageView
    }()
    
    private let greatLabel:UILabel = {
        let label = UILabel.init()
        label.text = "You did great"
        label.textColor = .white
        label.font = UIFont.russoOneFont(ofSize: 18)
        return label
    }()
    
    private let improveImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "learn_report_purple_icon")
        return imageView
    }()
    
    private let improveLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.text = "You need to improve"
        label.font = UIFont.russoOneFont(ofSize: 18)
        return label
    }()
    
    private let shareButton:UIButton = {
        let button = UIButton.init()
        button.setTitle("share", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    //MARK: —— View life cycle
    init(with model:SceneCourseStudySummary) {
        super.init(frame: CGRectZero)
        
        layer.addSublayer(gradientLayer)
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(reportScrollView)
        reportScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        quitButton.addTarget(self, action: #selector(quitButtonClick), for: .touchUpInside)
        reportScrollView.addSubview(quitButton)
        quitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(41)
        }
        
        reportScrollView.addSubview(reportBgView)
        reportBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.right.equalTo(self).offset(-42)
            make.height.equalTo(64)
            make.top.equalTo(quitButton.snp.bottom).offset(35)
        }
        
        reportScrollView.addSubview(dragonImageView)
        dragonImageView.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-24)
            make.size.equalTo(100)
            make.centerY.equalTo(reportBgView.snp.centerY)
        }
        
        reportScrollView.addSubview(reportTitleLabel)
        reportTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(reportBgView).offset(34)
            make.top.equalTo(reportBgView).offset(9)
            make.right.equalTo(dragonImageView.snp.left)
        }
        
        reportScrollView.addSubview(reportCoinLabel)
        reportCoinLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(reportBgView).offset(34)
            make.top.equalTo(reportTitleLabel.snp.bottom)
        }
        
        reportScrollView.addSubview(coinImageView)
        coinImageView.snp.makeConstraints { make in
            make.left.equalTo(reportCoinLabel.snp.right)
            make.centerY.equalTo(reportCoinLabel.snp.centerY)
            make.size.equalTo(22)
        }
        
        coinCountLabel.text = model.coinNum == nil ? "" : "+\(model.coinNum!)"
        reportScrollView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints { make in
            make.left.equalTo(coinImageView.snp.right).offset(4)
            make.centerY.equalTo(reportCoinLabel.snp.centerY)
            make.right.equalTo(dragonImageView.snp.left).priority(249)
        }
        
        reportScrollView.addSubview(cubeImageView)
        cubeImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(29)
            make.top.equalTo(reportBgView.snp.bottom).offset(48)
            make.width.equalTo(6)
            make.height.equalTo(14)
        }
        
        reportScrollView.addSubview(onBoardingLabel)
        onBoardingLabel.snp.makeConstraints { make in
            make.left.equalTo(cubeImageView.snp.right).offset(5)
            make.centerY.equalTo(cubeImageView.snp.centerY)
        }
        
        dayLabel.text = model.learningDays == nil ? "" : String(format: "DAY %02d", model.learningDays!)
        reportScrollView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).offset(-44)
            make.centerY.equalTo(cubeImageView.snp.centerY)
        }
        
        reportScrollView.addSubview(lineGradientView)
        lineGradientView.snp.makeConstraints { make in
            make.top.equalTo(onBoardingLabel.snp.bottom).offset(4)
            make.height.equalTo(2)
            make.left.equalToSuperview().offset(25)
            make.right.equalTo(self.snp.right).offset(-25)
        }
        
        reportScrollView.addSubview(timeProgressView)
        reportScrollView.addSubview(pronounceProgressView)
        reportScrollView.addSubview(fluencyProgressView)
        timeProgressView.snp.makeConstraints { make in
            make.top.equalTo(lineGradientView.snp.bottom).offset(49)
            make.left.equalToSuperview().offset(42)
            make.width.equalTo(pronounceProgressView)
            make.height.equalTo(timeProgressView.snp.width).multipliedBy(1)
        }
        
        pronounceProgressView.snp.makeConstraints { make in
            make.top.equalTo(lineGradientView.snp.bottom).offset(49)
            make.left.equalTo(timeProgressView.snp.right).offset(22)
            make.width.equalTo(fluencyProgressView)
            make.height.equalTo(pronounceProgressView.snp.width).multipliedBy(1)
        }
        
        fluencyProgressView.snp.makeConstraints { make in
            make.top.equalTo(lineGradientView.snp.bottom).offset(49)
            make.left.equalTo(pronounceProgressView.snp.right).offset(22)
            make.width.equalTo(timeProgressView)
            make.right.equalTo(self.snp.right).offset(-41)
            make.height.equalTo(fluencyProgressView.snp.width).multipliedBy(1)
        }
        
        reportScrollView.addSubview(timeImageView)
        timeImageView.snp.makeConstraints { make in
            make.top.equalTo(lineGradientView.snp.bottom).offset(15)
            make.width.equalTo(46)
            make.height.equalTo(26)
            make.centerX.equalTo(timeProgressView.snp.centerX)
        }

        reportScrollView.addSubview(pronounceImageView)
        pronounceImageView.snp.makeConstraints { make in
            make.top.equalTo(lineGradientView.snp.bottom).offset(15)
            make.width.equalTo(95)
            make.height.equalTo(26)
            make.centerX.equalTo(pronounceProgressView.snp.centerX)
        }
        
        reportScrollView.addSubview(fluenceImageView)
        fluenceImageView.snp.makeConstraints { make in
            make.top.equalTo(lineGradientView.snp.bottom).offset(15)
            make.width.equalTo(61)
            make.height.equalTo(26)
            make.centerX.equalTo(fluencyProgressView.snp.centerX)
        }
        
        let seconds = model.learningDuration ?? 0
        let minute = ceil(Double(seconds)/60.0)
        let attributeStr = NSMutableAttributedString(string: "\(Int(minute))min")
        attributeStr.addAttributes([.font:UIFont.montserratRegularFont(ofSize: 22)], range: NSMakeRange(0, attributeStr.length - 3))
        attributeStr.addAttributes([.font:UIFont.pingFangSCRFont(ofSize: 12)], range: NSMakeRange(attributeStr.length - 3, 3))
        timeDesLabel.attributedText = attributeStr
        reportScrollView.addSubview(timeDesLabel)
        timeDesLabel.snp.makeConstraints { make in
            make.center.equalTo(timeProgressView.snp.center)
            make.left.equalTo(timeProgressView).offset(5)
            make.right.equalTo(timeProgressView.snp.right).offset(-5)
        }
        
        if model.accuracy != nil {
            let attributeStr = NSMutableAttributedString(string: model.accuracy!)
            attributeStr.addAttributes([.font:UIFont.montserratRegularFont(ofSize: 22)], range: NSMakeRange(0, attributeStr.length - 1))
            attributeStr.addAttributes([.font:UIFont.pingFangSCRFont(ofSize: 12)], range: NSMakeRange(attributeStr.length - 1, 1))
            pronounceDesLabel.attributedText = attributeStr
        }
        reportScrollView.addSubview(pronounceDesLabel)
        pronounceDesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pronounceProgressView.snp.centerY)
            make.left.equalTo(pronounceProgressView).offset(5)
            make.right.equalTo(pronounceProgressView.snp.right).offset(-5)
        }
        
        if model.fluency != nil {
            let attributeStr = NSMutableAttributedString(string: model.fluency!)
            attributeStr.addAttributes([.font:UIFont.montserratRegularFont(ofSize: 22)], range: NSMakeRange(0, attributeStr.length - 1))
            attributeStr.addAttributes([.font:UIFont.pingFangSCRFont(ofSize: 12)], range: NSMakeRange(attributeStr.length - 1, 1))
            fluencyDesLabel.attributedText = attributeStr
        }
        reportScrollView.addSubview(fluencyDesLabel)
        fluencyDesLabel.snp.makeConstraints { make in
            make.center.equalTo(fluencyProgressView.snp.center)
            make.left.equalTo(fluencyProgressView).offset(5)
            make.right.equalTo(fluencyProgressView.snp.right).offset(-5)
        }
        
        reportScrollView.addSubview(conclutionImageView)
        conclutionImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(self.snp.right).offset(-12)
            make.top.equalTo(timeProgressView.snp.bottom).offset(15)
        }
        
        reportScrollView.addSubview(greatImageView)
        greatImageView.snp.makeConstraints { make in
            make.left.equalTo(conclutionImageView.snp.left).offset(30)
            make.top.equalTo(timeProgressView.snp.bottom).offset(50)
            make.size.equalTo(22)
        }
        
        reportScrollView.addSubview(greatLabel)
        greatLabel.snp.makeConstraints { make in
            make.left.equalTo(greatImageView.snp.right).offset(9)
            make.centerY.equalTo(greatImageView.snp.centerY)
        }
        
        var greatPreviousView:UIView?
        if model.greatSentence != nil {
            for index in 0..<model.greatSentence!.count {
                let title = model.greatSentence![index].content
                if title != nil {
                    let view = conclusionItemView(title: title!)
                    reportScrollView.addSubview(view)
                    view.snp.makeConstraints { make in
                        make.left.equalTo(reportScrollView.snp.left).offset(47)
                        make.right.equalTo(self.snp.right).offset(-47)
                        if greatPreviousView != nil {
                            make.top.equalTo(greatPreviousView!.snp.bottom).offset(16)
                        } else {
                            make.top.equalTo(greatImageView.snp.bottom).offset(16)
                        }
                    }
                    greatPreviousView = view
                }
            }
        }
        
        reportScrollView.addSubview(improveImageView)
        improveImageView.snp.makeConstraints { make in
            make.left.equalTo(conclutionImageView.snp.left).offset(30)
            if greatPreviousView != nil {
                make.top.equalTo(greatPreviousView!.snp.bottom).offset(15)
            } else {
                make.top.equalTo(greatImageView.snp.bottom).offset(35)
            }
            make.size.equalTo(22)
        }
        reportScrollView.addSubview(improveLabel)
        improveLabel.snp.makeConstraints { make in
            make.left.equalTo(improveImageView.snp.right).offset(9)
            make.centerY.equalTo(improveImageView.snp.centerY)
        }
        
        var improvePreviousView:UIView?
        if model.needImprovedSentence != nil {
            for index in 0..<model.needImprovedSentence!.count {
                let title = model.needImprovedSentence![index].content
                if title != nil {
                    let view = conclusionItemView(title: title!)
                    reportScrollView.addSubview(view)
                    view.snp.makeConstraints { make in
                        make.left.equalTo(reportScrollView.snp.left).offset(47)
                        make.right.equalTo(self.snp.right).offset(-47)
                        if improvePreviousView != nil {
                            make.top.equalTo(improvePreviousView!.snp.bottom).offset(16)
                        } else {
                            make.top.equalTo(improveImageView.snp.bottom).offset(16)
                        }
                    }
                    improvePreviousView = view
                }
            }
        }
        
        conclutionImageView.snp.makeConstraints { make in
            if improvePreviousView != nil {
                make.bottom.equalTo(improvePreviousView!.snp.bottom).offset(60)
            } else {
                make.bottom.equalTo(improveImageView.snp.bottom).offset(60)
            }
        }
        
        shareButton.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        reportScrollView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.equalTo(reportScrollView.snp.left).offset(32)
            make.right.equalTo(self.snp.right).offset(-32)
            make.height.equalTo(48)
            make.top.equalTo(conclutionImageView.snp.bottom).offset(26)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [self] in
            reportScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: CGRectGetMaxY(shareButton.frame))
        })
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: —— Action
    @objc private func quitButtonClick() {
        quitHandler?()
    }
    
    @objc private func shareButtonClick() {
        shareHandler?()
    }
    
    //MARK: —— Private method
    private func conclusionItemView(title:String) -> UIView {
        let contentView = UIView.init()
        let rightIndicator = UIImageView.init(image: UIImage(named: "learn_report_indicator_icon"))
        contentView.addSubview(rightIndicator)
        rightIndicator.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top).offset(1)
            make.width.equalTo(53)
            make.height.equalTo(2)
        }
        
        let borderView = VPPolygonBorderView.init()
        borderView.borderWidth = 1
        borderView.leftSpaces = (CGPoint(x: 3, y: 10),CGPointZero)
        borderView.topSpaces = (CGPoint(x: 10, y: 0),CGPointZero)
        borderView.rightSpaces = (CGPointZero,CGPoint(x: 3, y: 0))
        borderView.bottomSpaces = (CGPointZero,CGPoint(x: 3, y: 0))
        borderView.borderEndPoint = CGPoint(x: 1, y: 0)
        borderView.borderColors = [UIColor(hex6: 0x55EBFF).cgColor,UIColor(hex6: 0x6631FF).cgColor,UIColor(hex6: 0x814783).cgColor]
        contentView.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        let leftIndicator = UIImageView.init(image: UIImage(named: "learn_report_indicator_icon"))
        contentView.addSubview(leftIndicator)
        leftIndicator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(borderView.snp.bottom).offset(3)
            make.left.equalTo(contentView.snp.left)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        let titleLabel = UILabel.init()
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.font = UIFont.montserratRegularFont(ofSize: 14)
        titleLabel.textColor = UIColor(hex6: 0x6FB1FF)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(borderView).offset(21)
            make.top.equalTo(borderView).offset(12)
            make.right.equalTo(borderView.snp.right).offset(-21)
            make.bottom.equalTo(borderView.snp.bottom).offset(-12)
        }
        
        return contentView
    }
}
