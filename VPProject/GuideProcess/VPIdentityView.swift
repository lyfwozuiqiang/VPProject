//
//  VPIdentityCollectionCell.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/5.
//

import UIKit

class VPIdentityView: UIView {
    
    var identityInfo:ScenarioRole? {
        didSet {
            nameLabel.text = identityInfo?.roleName
            ageLabel.text = String(format: "%.01f / %@",identityInfo?.age ?? 0.0,identityInfo?.nature ?? "")
            let imageName:String
            switch identityInfo?.sex {
            case 0:
                imageName = "guide_female_icon"
            case 1:
                imageName = "guide_male_icon"
            default:
                imageName = ""
            }
            genderImageView.image = UIImage(named: imageName)
        }
    }
    
    private let backgroundImageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.main.bounds.size.width - 84, height: 348)))
        var image = UIImage(named: "guide_identity_card_bg_image")
        image = image?.stretchableImage(withLeftCapWidth: Int((image?.size.width ?? 0)/2), topCapHeight: Int((image?.size.height ?? 0)/2))
        imageView.image = image
        return imageView
    }()
    
    
    // 姓名
    private let nameLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.font = UIFont.montserratRegularFont(ofSize: 28)
        return label
    }()
    
    // 年龄 + 性格？
    private let ageLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.text = "24 tuổi / hoạt bát"
        label.font = UIFont.montserratRegularFont(ofSize: 12)
        return label
    }()
    
    // 主题
    private let themeLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(hex6: 0x69E4F6)
        label.text = "Chủ đề :"
        label.font = UIFont.montserratRegularFont(ofSize: 12)
        return label
    }()
    
    // 主题描述
    private let themeDesLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.text = "Sinh sống ở nơi làm việc"
        label.font = UIFont.montserratRegularFont(ofSize: 14)
        return label
    }()
    
    // 难度水平
    private let levelLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(hex6: 0x69E4F6)
        label.text = "Cấp độ : "
        label.font = UIFont.montserratRegularFont(ofSize: 12)
        return label
    }()
    
    // 难度水平描述
    private let levelDesLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.text = "Trung cấp"
        label.font = UIFont.montserratRegularFont(ofSize: 14)
        return label
    }()
    
    // 学习时间
    private let learnTimeLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(hex6: 0x69E4F6)
        label.text = "Thời gian học tập : "
        label.font = UIFont.montserratRegularFont(ofSize: 12)
        return label
    }()
    
    // 学习时间描述
    private let learnTimeDesLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.text = "70 ngày"
        label.font = UIFont.montserratRegularFont(ofSize: 14)
        return label
    }()
    
    private let genderImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "guide_female_icon")
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        layoutUserInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: —— Private method
    // 布局用户页面
    private func layoutUserInterface() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(348)
            make.centerY.equalToSuperview()
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(backgroundImageView).offset(24)
        }
        
        addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        let lineView:VPGradientView = VPGradientView.init()
        lineView.backgroundColors = [UIColor(hex6: 0x58CAFF).cgColor,UIColor(hex6: 0x58CAFF).cgColor,UIColor(hex6: 0x58CAFF,alpha: 0).cgColor]
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(ageLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        addSubview(themeLabel)
        themeLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(lineView.snp.bottom).offset(24)
        }
        
        addSubview(themeDesLabel)
        themeDesLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(themeLabel.snp.bottom).offset(4)
        }
        
        addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(themeDesLabel.snp.bottom).offset(24)
        }
        
        addSubview(levelDesLabel)
        levelDesLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(levelLabel.snp.bottom).offset(4)
        }
        
        addSubview(learnTimeLabel)
        learnTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(levelDesLabel.snp.bottom).offset(24)
        }
        
        addSubview(learnTimeDesLabel)
        learnTimeDesLabel.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView).offset(32)
            make.right.equalTo(backgroundImageView.snp.right).offset(-32)
            make.top.equalTo(learnTimeLabel.snp.bottom).offset(4)
        }
        
        addSubview(genderImageView)
        genderImageView.snp.makeConstraints { make in
            make.left.equalTo(backgroundImageView.snp.left).offset(32)
            make.top.equalTo(learnTimeDesLabel.snp.bottom).offset(22)
            make.size.equalTo(20)
        }
    }
}
