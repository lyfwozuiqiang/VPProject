//
//  VPLeftConversationCell.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/9.
//

import UIKit

class VPLeftConversationCell: UITableViewCell {
  
  var questionItem:QuestionItem? {
    didSet {
      conversationView.dialogText = questionItem?.targetDefinition
      conversationView.titleText = "???"
    }
  }
  
  private let conversationView:VPLeftConversationView = {
    let view = VPLeftConversationView.init()
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none

    contentView.addSubview(conversationView)
    conversationView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
