//
//  VPQuestionHeaderView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/12.
//

import UIKit

class VPQuestionHeaderView: UIView {

  var titleText:String? {
    didSet {
      conversationView.titleText = titleText
    }
  }
  
  var dialogText:String? {
    didSet {
      conversationView.dialogText = dialogText
    }
  }
  
  var indicatorText:String? {
    didSet {
      enterLabel.text = indicatorText
    }
  }
  
  private let conversationView:VPLeftConversationView = {
    let view = VPLeftConversationView.init()
    return view
  }()
  
  private let enterLabel:UILabel = {
    let label = UILabel()
    label.font = UIFont.russoOneFont(ofSize: 14)
    label.textColor = UIColor(hex6: 0x7CC0FF)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(conversationView)
    conversationView.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }
    
    addSubview(enterLabel)
    enterLabel.snp.makeConstraints { make in
      make.right.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(87)
      make.top.equalTo(conversationView.snp.bottom).offset(20)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
