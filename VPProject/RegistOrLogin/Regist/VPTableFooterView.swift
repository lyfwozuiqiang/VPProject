//
//  VPTableFooterView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/13.
//

import UIKit

class VPTableFooterView: UIView,UITextFieldDelegate {
  
  var inviteString:String? {
    get {
      return inviteCodeTextField.text
    }
  }
  
  var accountString:String? {
    get {
      return accountTextField.text
    }
  }
  
  var passwordString:String? {
    get {
      return passwordTextField.text
    }
  }
  
  // 邀请码背景框
  private let inviteCodeBgView:VPPolygonBorderView = {
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
  
  // 账号输入框
  private let inviteCodeTextField:UITextField = {
      let textField = UITextField.init()
      textField.textColor = .white
      textField.tintColor = UIColor(hex6: 0x69E4F6)
      textField.font = UIFont.montserratRegularFont(ofSize: 14)
      let attributeString:NSAttributedString = NSAttributedString(string: "Invitation code:",attributes: [.font:UIFont.montserratRegularFont(ofSize: 14),.foregroundColor:UIColor.init(hex6: 0x8598FF)])
      textField.attributedPlaceholder = attributeString
      textField.keyboardType = .asciiCapable
      textField.returnKeyType = .next
      return textField
  }()
  
  // 邀请码错误提示
  private let errorInvateCodeLabel:UILabel = {
    let label = UILabel.init()
    label.text = "* Invalid invitation code"
    label.font = UIFont.pingFangSCRFont(ofSize: 14)
    label.textColor = UIColor(hex6: 0xF64B40)
    return label
  }()
  
  // 账号背景框
  private let accountBgView:VPPolygonBorderView = {
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
  
  // 账号输入框
  private let accountTextField:UITextField = {
      let textField = UITextField.init()
      textField.textColor = .white
      textField.tintColor = UIColor(hex6: 0x69E4F6)
      textField.font = UIFont.montserratRegularFont(ofSize: 14)
      let attributeString:NSAttributedString = NSAttributedString(string: "Email adress",attributes: [.font:UIFont.montserratRegularFont(ofSize: 14),.foregroundColor:UIColor.init(hex6: 0x8598FF)])
      textField.attributedPlaceholder = attributeString
      textField.keyboardType = .emailAddress
      textField.returnKeyType = .next
      return textField
  }()
  
  // 账号错误提示
  private let errorAccountLabel:UILabel = {
    let label = UILabel.init()
    label.text = "* Please enter a valid email address"
    label.font = UIFont.pingFangSCRFont(ofSize: 14)
    label.textColor = UIColor(hex6: 0xF64B40)
    return label
  }()
  
  // 密码背景框
  private let passwordBgView:VPPolygonBorderView = {
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
  
  // 密码输入框
  private let passwordTextField:UITextField = {
      let textField = UITextField.init()
      textField.textColor = .white
      textField.isSecureTextEntry = true
      textField.tintColor = UIColor(hex6: 0x69E4F6)
      textField.font = UIFont.montserratRegularFont(ofSize: 14)
      let attributeString:NSAttributedString = NSAttributedString(string: "Password: 8+ characters",attributes: [.font:UIFont.montserratRegularFont(ofSize: 14),.foregroundColor:UIColor.init(hex6: 0x8598FF)])
      textField.attributedPlaceholder = attributeString
      textField.keyboardType = .asciiCapable
      textField.returnKeyType = .done
      return textField
  }()
  
  // 密码错误提示
  private let errorPasswordLabel:UILabel = {
    let label = UILabel.init()
    label.text = "* Please enter a valid password"
    label.font = UIFont.pingFangSCRFont(ofSize: 14)
    label.textColor = UIColor(hex6: 0xF64B40)
    return label
  }()
  
  // 登录按钮
  let confirmButton:UICommonButton = {
      let button:UICommonButton = UICommonButton.init(style: .gradientPurple)
      button.updateImage(UIImage(named: "login_arrow_icon")?.withRenderingMode(.alwaysOriginal))
      button.alpha = 0.4
      button.isEnabled = false
      return button
  }()

  // MARK: —— View life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let questionView:VPQuestionHeaderView = VPQuestionHeaderView()
    questionView.titleText = "T-Rex"
    questionView.dialogText = "Rất tốt, hãy tạo ra một tài khoản và hoàn thành đăng ký nhé."
    questionView.indicatorText = "·Please enter..."
    addSubview(questionView)
    questionView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }
    
    // 添加邀请码不规则多边形背景
    addSubview(inviteCodeBgView)
    inviteCodeBgView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(87)
      make.right.equalTo(snp.right).offset(-20)
      make.height.equalTo(42)
      make.top.equalTo(questionView.snp.bottom).offset(20)
    }
    
    // 添加邀请码输入框
    inviteCodeTextField.delegate = self
    addSubview(inviteCodeTextField)
    inviteCodeTextField.snp.makeConstraints { make in
      make.left.equalTo(inviteCodeBgView.snp.left).offset(18)
      make.right.equalTo(inviteCodeBgView.snp.right).offset(18)
      make.centerY.equalTo(inviteCodeBgView)
      make.height.equalTo(42)
    }
    
    // 添加邀请码错误提示
    addSubview(errorInvateCodeLabel)
    errorInvateCodeLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(87)
      make.right.equalTo(snp.right).offset(-20)
      make.height.greaterThanOrEqualTo(10)
      make.top.equalTo(inviteCodeBgView.snp.bottom).offset(8)
    }
    
    // 添加账号不规则多边形背景
    addSubview(accountBgView)
    accountBgView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(87)
      make.right.equalTo(snp.right).offset(-20)
      make.height.equalTo(42)
      make.top.equalTo(errorInvateCodeLabel.snp.bottom).offset(12)
    }
    
    let accountIconImageView:UIImageView = UIImageView(image: UIImage(named: "login_email_icon")?.withRenderingMode(.alwaysOriginal))
    addSubview(accountIconImageView)
    accountIconImageView.snp.makeConstraints { make in
      make.left.equalTo(accountBgView).offset(20)
      make.centerY.equalTo(accountBgView)
      make.size.equalTo(24)
    }
    
    // 添加账号输入框
    accountTextField.delegate = self
    addSubview(accountTextField)
    accountTextField.snp.makeConstraints { make in
      make.left.equalTo(accountIconImageView.snp.right).offset(12)
      make.right.equalTo(accountBgView.snp.right).offset(-12)
      make.centerY.equalTo(accountBgView)
      make.height.equalTo(42)
    }
    
    // 添加账号错误提示
    addSubview(errorAccountLabel)
    errorAccountLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(87)
      make.right.equalTo(snp.right).offset(-20)
      make.height.greaterThanOrEqualTo(0)
      make.top.equalTo(accountBgView.snp.bottom).offset(8)
    }
    
    
    // 添加密码不规则多边形背景
    addSubview(passwordBgView)
    passwordBgView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(87)
      make.right.equalTo(snp.right).offset(-20)
      make.height.equalTo(42)
      make.top.equalTo(errorAccountLabel.snp.bottom).offset(12)
    }
    
    let passwordIconImageView:UIImageView = UIImageView(image: UIImage(named: "login_password_icon")?.withRenderingMode(.alwaysOriginal))
    addSubview(passwordIconImageView)
    passwordIconImageView.snp.makeConstraints { make in
        make.left.equalTo(passwordBgView).offset(20)
        make.centerY.equalTo(passwordBgView)
        make.size.equalTo(24)
    }
    
    // 添加密码输入框
    passwordTextField.delegate = self
    addSubview(passwordTextField)
    passwordTextField.snp.makeConstraints { make in
      make.left.equalTo(accountIconImageView.snp.right).offset(12)
      make.centerY.equalTo(passwordBgView)
      make.height.equalTo(42)
    }
    
    // 添加密码输入切换
    let safeInputButton = UIButton.init(type: .custom)
    safeInputButton.setImage(UIImage(named: "login_safe_input_open_icon"), for: .normal)
    safeInputButton.addTarget(self, action: #selector(safeInputButtonClick), for: .touchUpInside)
    addSubview(safeInputButton)
    safeInputButton.snp.makeConstraints { make in
      make.size.equalTo(44)
      make.left.equalTo(passwordTextField.snp.right).offset(8)
      make.right.equalTo(passwordBgView.snp.right)
      make.centerY.equalTo(passwordBgView.snp.centerY)
    }
    
    // 添加账号错误提示
    addSubview(errorPasswordLabel)
    errorPasswordLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(87)
      make.right.equalTo(snp.right).offset(-20)
      make.height.greaterThanOrEqualTo(0)
      make.top.equalTo(passwordBgView.snp.bottom).offset(8)
    }
    
    // 添加登录按钮
    addSubview(confirmButton)
    confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
    confirmButton.snp.makeConstraints { make in
      make.size.equalTo(48)
      make.top.equalTo(errorPasswordLabel.snp.bottom).offset(16)
      make.centerX.equalTo(passwordBgView.snp.centerX)
      make.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: —— Action
  // 返回按钮点击事件
  @objc private func safeInputButtonClick(button:UIButton) {
      button.isSelected = !button.isSelected
      let image:UIImage?
      if button.isSelected {
          image = UIImage(named: "login_safe_input_close_icon")
      } else {
          image = UIImage(named: "login_safe_input_open_icon")
      }
      button.setImage(image, for: .normal)
      passwordTextField.isSecureTextEntry = !button.isSelected
  }
  
  @objc private func confirmButtonClick() {
      endEditing(true)
  }
  
  // MARK: —— Private method
  // 设置loginButton按钮状态
  private func enableLoginButton(enable:Bool) {
      confirmButton.alpha = enable ? 1 : 0.4
      confirmButton.isEnabled = enable
  }
  
  // 账号及密码是否合法
  private func isInputLegal() -> Bool {
    return accountTextField.text?.count ?? 0 > 5 && passwordTextField.text?.count ?? 0 > 5 && inviteCodeTextField.text?.count ?? 0 > 5
  }
}
