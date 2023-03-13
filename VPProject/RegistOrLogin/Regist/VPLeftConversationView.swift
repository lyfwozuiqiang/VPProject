//
//  VPLeftConversationView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/12.
//

import UIKit

class VPLeftConversationView: UIView {

  var titleText:String? {
    didSet {
      titleLabel.text = titleText
    }
  }
  
  var dialogText:String? {
    didSet {
      dialogTextLabel.text = dialogText
    }
  }
  
  private let gradientView:VPGradientView = {
    let view = VPGradientView.init()
    view.backgroundColors = [UIColor(hex6: 0x5081FF).cgColor,UIColor(hex6: 0x5081FF, alpha: 0).cgColor]
    return view
  }()
  
  private let titleLabel:UILabel = {
    let label = UILabel.init()
    label.font = UIFont.russoOneFont(ofSize: 14)
    label.textColor = UIColor(hex6: 0x090D17)
    return label
  }()
  
  var attributeText:String? {
    didSet {
      if attributeText != nil {
        let attributeString = NSMutableAttributedString(string: attributeText!)
        let range = (attributeText! as NSString).range(of: "https://discord.gg/raJvkrx84A")
        attributeString.addAttributes([.foregroundColor:UIColor(hex6: 0x55EBFF),.underlineStyle:NSUnderlineStyle.single.rawValue,.underlineColor:UIColor(hex6: 0x55EBFF),.baselineOffset:5], range: range)
        dialogTextLabel.attributedText = attributeString
      }
    }
  }
  
  private let dragenImageView:UIImageView = {
    let imageView = UIImageView.init()
    imageView.image = UIImage(named: "regist_dialog_dragon_image")
    return imageView
  }()
  
  private let dialogBgView:VPPolygonBorderView = {
    let view = VPPolygonBorderView.init()
    view.borderEndPoint = CGPoint(x: 1, y: 0)
    view.borderWidth = 1
    view.borderColors = [UIColor(hex6: 0x4598FA, alpha: 0.24).cgColor,UIColor(hex6: 0x789EFF).cgColor]
    view.backgroundColors = [UIColor(hex6: 0x5081FF, alpha: 0).cgColor,UIColor(hex6: 0x5081FF, alpha: 0.32).cgColor,UIColor(hex6: 0x8E88FF, alpha: 0.32).cgColor,UIColor(hex6: 0x8E88FF, alpha: 0.18).cgColor]
    view.rightSpaces = (CGPoint.zero,CGPoint(x: 0, y: 10))
    view.bottomSpaces = (CGPoint.zero,CGPoint(x: 10, y: 0))
    return view
  }()
  
  private let dialogTextLabel:UILabel = {
    let label = UILabel.init()
    label.numberOfLines = 0
    label.textColor = .white
    label.text = "Trước hết, hãy cho tôi biết mục đích của bạn học tiếng Anh là gì nhé."
    label.font = UIFont.systemFont(ofSize: 14)
    label.isUserInteractionEnabled = true
    return label
  }()
  
  private let typingLabel:UILabel = {
    let label = UILabel.init()
    label.textColor = UIColor(hex6: 0x7CC0FF)
    label.text = "Typing..."
    label.isHidden = true
    label.font = UIFont.pingFangSCRFont(ofSize: 12)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    
    addSubview(gradientView)
    addSubview(dragenImageView)
    dragenImageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(20)
      make.top.equalToSuperview()
      make.size.equalTo(72)
    }
    
    gradientView.snp.makeConstraints { make in
      make.left.equalTo(dragenImageView.snp.centerX)
      make.centerY.equalTo(dragenImageView.snp.centerY)
      make.height.equalTo(26)
      make.width.lessThanOrEqualTo(258)
    }
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(dragenImageView.snp.right).offset(8)
      make.right.equalTo(gradientView.snp.right).offset(-32)
      make.centerY.equalTo(dragenImageView.snp.centerY)
    }
    
    insertSubview(dialogBgView, belowSubview: dragenImageView)
    dialogBgView.snp.makeConstraints { make in
      make.left.equalTo(dragenImageView.snp.centerX)
      make.top.equalTo(gradientView.snp.bottom)
      make.bottom.equalToSuperview().offset(-27)
    }
    
    let cornerImageView:UIImageView = UIImageView.init(image: UIImage(named: "regist_dialog_corner_icon")?.withRenderingMode(.alwaysOriginal))
    addSubview(cornerImageView)
    cornerImageView.snp.makeConstraints { make in
      make.right.equalTo(dialogBgView.snp.right).offset(0.5)
      make.top.equalTo(dialogBgView.snp.top).offset(-0.5)
    }
    
    addSubview(dialogTextLabel)
    dialogTextLabel.snp.makeConstraints { make in
      make.left.equalTo(dragenImageView.snp.right).offset(8)
      make.right.equalTo(dialogBgView.snp.right).offset(-16)
      make.top.equalTo(dialogBgView.snp.top).offset(12)
      make.bottom.equalTo(dialogBgView.snp.bottom).offset(-12)
      make.width.lessThanOrEqualTo(200)
    }
    
    addSubview(typingLabel)
    typingLabel.snp.makeConstraints { make in
      make.left.equalTo(dragenImageView.snp.centerX)
      make.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
