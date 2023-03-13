//
//  VPRightAnswerCell.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/12.
//

import UIKit

protocol VPRightAnswerCellDelegate:NSObjectProtocol {
  func expandButtonClick(at cell:VPRightAnswerCell)
}

class VPRightAnswerCell: UITableViewCell {
  
  weak var delegate:VPRightAnswerCellDelegate?
  
  var isExpandStatus:Bool = true
  var questionItem:QuestionItem? {
    didSet {
      questionLabel.text = questionItem?.targetDefinition
      if isExpandStatus {
        if questionItem?.isSelected == true {
          selectedIndicatorImageView.isHidden = false
          expandButton.isHidden = true
          selectionLabel.isHidden = false
          dialogBgView.borderWidth = 1.5
          dialogBgView.borderColors = [UIColor(hex6: 0xD3DDFF).cgColor]
        } else {
          selectedIndicatorImageView.isHidden = true
          expandButton.isHidden = true
          selectionLabel.isHidden = false
          dialogBgView.borderWidth = 0.5
          dialogBgView.borderColors = [UIColor(hex6: 0x4598FA, alpha: 0.24).cgColor,UIColor(hex6: 0x789EFF).cgColor]
        }
        dialogBgView.backgroundColors = [UIColor(hex6: 0xD4B1FF, alpha: 1).cgColor,UIColor(hex6: 0x5081FF, alpha: 0.48).cgColor,UIColor(hex6: 0x8E88FF, alpha: 0.2).cgColor]
        questionLabel.snp.updateConstraints { make in
          make.left.equalTo(selectionLabel.snp.right).offset(16)
          make.right.equalTo(dialogBgView.snp.right).offset(-40)
          make.width.greaterThanOrEqualTo(196)
        }
      } else {
        selectedIndicatorImageView.isHidden = true
        expandButton.isHidden = false
        selectionLabel.isHidden = true
        dialogBgView.backgroundColors = [UIColor(hex6: 0xD4B1FF).cgColor,UIColor(hex6: 0x5081FF).cgColor,UIColor(hex6: 0x8E88FF, alpha: 0.7).cgColor]
        questionLabel.snp.updateConstraints { make in
          make.left.equalTo(selectionLabel.snp.right).offset(-10)
          make.right.equalTo(dialogBgView.snp.right).offset(-16)
        }
        dialogBgView.borderWidth = 0.5
        dialogBgView.borderColors = [UIColor(hex6: 0x4598FA, alpha: 0.24).cgColor,UIColor(hex6: 0x789EFF).cgColor]
        questionLabel.snp.updateConstraints { make in
          make.left.equalTo(selectionLabel.snp.right).offset(-18)
          make.right.equalTo(dialogBgView.snp.right).offset(-16)
          make.width.greaterThanOrEqualTo(10)
        }
      }
    }
  }
  
  var rowIndex:Int = 0 {
    didSet {
      selectionLabel.text = String(Character(UnicodeScalar(65 + rowIndex) ?? UnicodeScalar(65)))
    }
  }

  private let dialogBgView:VPPolygonBorderView = {
    let view = VPPolygonBorderView.init()
    view.borderEndPoint = CGPoint(x: 1, y: 0)
    view.backgroundEndPoint = CGPoint(x: 1, y: 0)
    view.borderWidth = 0.5
    view.borderColors = [UIColor(hex6: 0x4598FA, alpha: 0.24).cgColor,UIColor(hex6: 0x789EFF).cgColor]
    view.backgroundColors = [UIColor(hex6: 0xD4B1FF, alpha: 1).cgColor,UIColor(hex6: 0x5081FF, alpha: 0.48).cgColor,UIColor(hex6: 0x8E88FF, alpha: 0.2).cgColor]
    view.leftSpaces = (CGPoint(x: 0, y: 10),CGPoint.zero)
    view.topSpaces = (CGPoint(x: 10, y: 00),CGPoint.zero)
    view.rightSpaces = (CGPoint.zero,CGPoint(x: 0, y: 10))
    view.bottomSpaces = (CGPoint.zero,CGPoint(x: 10, y: 0))
    return view
  }()
  
  private let selectionLabel:UILabel = {
    let label = UILabel.init()
    label.font = UIFont.montserratRegularFont(ofSize: 16)
    label.textColor = UIColor(hex6: 0x090D17)
    return label
  }()
  
  private let questionLabel:UILabel = {
    let label = UILabel.init()
    label.font = UIFont.montserratRegularFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  private let selectedIndicatorImageView:UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "regist_answer_selected_icon"))
    imageView.isHidden = true
    return imageView
  }()
  
  private let expandButton:UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "regist_expand_answer_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
    button.isHidden = true
    return button
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none
    
    contentView.addSubview(dialogBgView)
    dialogBgView.snp.makeConstraints { make in
      make.left.greaterThanOrEqualToSuperview().offset(87)
      make.right.equalToSuperview().offset(-20)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview().offset(-12)
    }
    
    contentView.addSubview(selectionLabel)
    selectionLabel.snp.makeConstraints { make in
      make.left.equalTo(dialogBgView).offset(20)
      make.height.equalTo(18)
      make.width.equalTo(14)
      make.centerY.equalToSuperview().offset(-6)
    }
    
    contentView.addSubview(questionLabel)
    questionLabel.snp.makeConstraints { make in
      make.left.equalTo(selectionLabel.snp.right).offset(16)
      make.right.equalTo(dialogBgView.snp.right).offset(-40)
      make.top.equalTo(dialogBgView.snp.top).offset(12)
      make.bottom.equalTo(dialogBgView.snp.bottom).offset(-12)
      make.width.greaterThanOrEqualTo(196)
    }
    
    contentView.addSubview(selectedIndicatorImageView)
    selectedIndicatorImageView.snp.makeConstraints { make in
      make.right.equalTo(dialogBgView.snp.right).offset(-9)
      make.size.equalTo(24)
      make.centerY.equalTo(dialogBgView)
    }
    
    expandButton.addTarget(self, action: #selector(expandButtonClick), for: .touchUpInside)
    contentView.addSubview(expandButton)
    expandButton.snp.makeConstraints { make in
      make.right.equalTo(dialogBgView.snp.left).offset(-9)
      make.size.equalTo(44)
      make.centerY.equalTo(dialogBgView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: —— Action
  @objc func expandButtonClick() {
    delegate?.expandButtonClick(at: self)
  }
}
