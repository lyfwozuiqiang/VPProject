//
//  VPLanguageItemCell.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/6.
//

import UIKit

struct LanguageModel {
    let flag:String
    let language:String
    var isSelected:Bool
}

class VPLanguageItemCell: UITableViewCell {
    
    var languageModel:LanguageModel = LanguageModel(flag: "", language: "", isSelected: false) {
        didSet {
            flagImageView.image = UIImage(named: languageModel.flag)
            countryLabel.text = languageModel.language
            indicatorImageView.isHidden = !languageModel.isSelected
        }
    }
    
    // 国旗
    private let flagImageView:UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    // 国家名称
    private let countryLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    // 选中状态指示
    private let indicatorImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.isHidden = true
        imageView.image = UIImage(named: "select_langeuage_indicator_icon")
        return imageView
    }()

    private let borderBgView:VPPolygonBorderView = {
        let view = VPPolygonBorderView.init()
        view.borderWidth = 1
        view.borderEndPoint = CGPoint(x: 1, y: 0)
        view.borderColors = [UIColor(hex6: 0x6A50B7).cgColor,UIColor(hex6: 0x566DD2).cgColor]
        view.backgroundEndPoint = CGPoint(x: 1, y: 0)
        view.backgroundColors = [UIColor(hex6: 0x6F48DE, alpha: 0.4).cgColor,UIColor(hex6: 0x64F68D6, alpha: 0.4).cgColor]
        view.topSpaces = (CGPoint(x: 10, y: 0),CGPointZero)
        view.leftSpaces = (CGPoint(x: 0, y: 10),CGPointZero)
        view.rightSpaces = (CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 10))
        view.bottomSpaces = (CGPointZero,CGPoint(x: 10, y: 0))
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(borderBgView)
        borderBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalTo(contentView.snp.right).offset(-32)
            make.top.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalTo(borderBgView.snp.left).offset(27)
            make.centerY.equalTo(borderBgView.snp.centerY)
        }
        
        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(flagImageView.snp.right).offset(23)
            make.centerY.equalTo(borderBgView.snp.centerY)
        }
        
        contentView.addSubview(indicatorImageView)
        indicatorImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(borderBgView.snp.centerY)
            make.left.equalTo(countryLabel.snp.right).offset(15)
            make.right.equalTo(borderBgView.snp.right).offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
