//
//  VPLoginController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/6.
//  登录控制器

import UIKit

class VPLoginController: UIViewController,UITextFieldDelegate {
    
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
        textField.font = UIFont.montserratRegularFont(ofSize: 16)
        let attributeString:NSAttributedString = NSAttributedString(string: "Email adress",attributes: [.font:UIFont.montserratRegularFont(ofSize: 16),.foregroundColor:UIColor.init(hex6: 0x8598FF)])
        textField.attributedPlaceholder = attributeString
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
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
        textField.tintColor = UIColor(hex6: 0x69E4F6)
        textField.font = UIFont.montserratRegularFont(ofSize: 16)
        let attributeString:NSAttributedString = NSAttributedString(string: "Password",attributes: [.font:UIFont.montserratRegularFont(ofSize: 16),.foregroundColor:UIColor.init(hex6: 0x8598FF)])
        textField.attributedPlaceholder = attributeString
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .done
        return textField
    }()
    
    // 错误信息提示Label
    private let errorLabel:UILabel = {
        let label:UILabel = UILabel.init()
        label.font = UIFont.pingFangSCRFont(ofSize: 14)
        label.text = "* Incorrect email or password"
        label.textAlignment = .center
        label.isHidden = true
        label.textColor = UIColor(hex6: 0xF64B40)
        return label
    }()
    
    // 登录按钮
    let loginButton:UICommonButton = {
        let button:UICommonButton = UICommonButton.init(style: .gradientPurple)
        button.updateImage(UIImage(named: "login_arrow_icon")?.withRenderingMode(.alwaysOriginal))
        button.alpha = 0.4
        button.isEnabled = false
        return button
    }()
    
    // 是否第一次进入页面 如果第一次 则自动弹起键盘
    private var firstEnterViewController:Bool = false
    // 是否已经发送过登录验证 如果发送了验证且在等待过程 loginButton 置灰、不可点击
    private var isSendLoginVerification:Bool = false

    // MARK: —— Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // 布局用户页面
        layoutUserInterface()
        // 监听文字变化
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditingChanged), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !firstEnterViewController {
            firstEnterViewController = true
            accountTextField.becomeFirstResponder()
        }
    }
    
    // MARK: —— Notification
    @objc func textFieldEditingChanged(notification:Notification) {
        guard let textField:UITextField = notification.object as? UITextField else {
            return
        }
        // 如果没有高亮输入状态文字再确认 loginButton 状态
        if textField.markedTextRange == nil {
            enableLoginButton(enable: isAccountOrPasswordLegal())
        }
    }
    
    // MARK: —— Action
    // view点击事件 收回键盘
    @objc private func viewTapHandle() {
        view.endEditing(true)
    }
    
    // 返回按钮点击事件
    @objc private func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
    // 注册按钮点击事件
    @objc private func signUpButtonClick() {
        let selectlanguageVc = VPSelectLanguageController.init()
        navigationController?.pushViewController(selectlanguageVc, animated: true)
        var viewcontrollers = navigationController?.viewControllers
        let index:Int? = viewcontrollers?.lastIndex(of: selectlanguageVc)
        if index ?? 0 > 1 {
            viewcontrollers?.remove(at: index! - 1)
            navigationController?.viewControllers = viewcontrollers!
        }
    }
    
    // MARK: —— UITextFieldDelegate
    // 如果账号TextField处于第一响应者 则边框加粗变色
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
            accountBgView.borderWidth = 2
            accountBgView.borderColors = [UIColor(hex6: 0x9875FF).cgColor,UIColor(hex6: 0x718BFF).cgColor]
        } else if textField == passwordTextField {
            passwordBgView.borderWidth = 2
            passwordBgView.borderColors = [UIColor(hex6: 0x9875FF).cgColor,UIColor(hex6: 0x718BFF).cgColor]
        }
    }
    
    // 如果账号TextField放弃第一响应者 则边框变细还原边框颜色
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountTextField {
            accountBgView.borderWidth = 1
            accountBgView.borderColors = [UIColor(hex6: 0x6A50B7).cgColor,UIColor(hex6: 0x566DD2).cgColor]
        } else if textField == passwordTextField {
            passwordBgView.borderWidth = 1
            passwordBgView.borderColors = [UIColor(hex6: 0x6A50B7).cgColor,UIColor(hex6: 0x566DD2).cgColor]
        }
    }
    
    // 键盘Return事件，如果是账号TextField则切换密码输入框为第一响应者
    // 如果是密码TextField且输入合法则直接调用登录接口
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField  {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if isAccountOrPasswordLegal() {
                textField.endEditing(true)
                isSendLoginVerification = true
                enableLoginButton(enable: false)
            }
        }
        
        return true
    }
    
    // MARK: —— Private method
    private func layoutUserInterface() {
        // self.view 添加点击事件
        let viewTapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapHandle))
        view.addGestureRecognizer(viewTapGesture)
        
        // 添加背景图片
        let bgImageView:UIImageView = UIImageView(image: UIImage(named: "login_regist_bg_image"))
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 添加返回按钮
        let backButton:UIButton = UIButton.init(type: .system)
        let backImage:UIImage? = UIImage(named: "login_regist_back_icon")?.withRenderingMode(.alwaysOriginal)
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        let welcomeLabel:UILabel = UILabel.init()
        welcomeLabel.text = "Welcome back"
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont.russoOneFont(ofSize: 24)
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        let lineView:VPGradientView = VPGradientView.init()
        lineView.backgroundColors = [UIColor(hex6: 0x4F6EF4, alpha: 0).cgColor,UIColor(hex6: 0x4F6EF4).cgColor,UIColor(hex6: 0x4F6EF4, alpha: 0).cgColor]
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(240)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // 添加账号不规则多边形背景
        view.addSubview(accountBgView)
        accountBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
            make.height.equalTo(54)
            make.top.equalTo(lineView).offset(48)
        }
        
        let accountIconImageView:UIImageView = UIImageView(image: UIImage(named: "login_email_icon")?.withRenderingMode(.alwaysOriginal))
        view.addSubview(accountIconImageView)
        accountIconImageView.snp.makeConstraints { make in
            make.left.equalTo(accountBgView).offset(20)
            make.centerY.equalTo(accountBgView)
            make.size.equalTo(24)
        }
        
        // 添加账号输入框
        accountTextField.delegate = self
        view.addSubview(accountTextField)
        accountTextField.snp.makeConstraints { make in
            make.left.equalTo(accountIconImageView.snp.right).offset(12)
            make.right.equalTo(accountBgView.snp.right).offset(-12)
            make.centerY.equalTo(accountBgView)
            make.height.equalTo(44)
        }
        
        // 添加密码不规则多边形背景
        view.addSubview(passwordBgView)
        passwordBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
            make.height.equalTo(54)
            make.top.equalTo(accountBgView.snp.bottom).offset(20)
        }
        
        let passwordIconImageView:UIImageView = UIImageView(image: UIImage(named: "login_password_icon")?.withRenderingMode(.alwaysOriginal))
        view.addSubview(passwordIconImageView)
        passwordIconImageView.snp.makeConstraints { make in
            make.left.equalTo(passwordBgView).offset(20)
            make.centerY.equalTo(passwordBgView)
            make.size.equalTo(24)
        }
        
        // 添加密码输入框
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.left.equalTo(accountIconImageView.snp.right).offset(12)
            make.right.equalTo(passwordBgView.snp.right).offset(-12)
            make.centerY.equalTo(passwordBgView)
            make.height.equalTo(44)
        }
        
        let centerView:UIView = UIView.init()
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordBgView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        let noAccountLabel:UILabel = UILabel.init()
        noAccountLabel.text = "Don't have an account?"
        noAccountLabel.font = UIFont.pingFangSCRFont(ofSize: 14)
        noAccountLabel.textColor = .white
        centerView.addSubview(noAccountLabel)
        noAccountLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        // 添加注册按钮
        let signUpButton:UIButton = UIButton.init(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.pingFangSCRFont(ofSize: 14)
        signUpButton.setTitleColor(UIColor(hex6: 0x69E4F6), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonClick), for: .touchUpInside)
        centerView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.left.equalTo(noAccountLabel.snp.right).offset(8)
            make.right.bottom.top.equalTo(centerView)
        }
        
        // 添加登录按钮
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.size.equalTo(76)
            make.top.equalTo(centerView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        // 添加错误信息Label
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalTo(passwordBgView.snp.bottom).offset(12)
        }
    }
    
    // 账号及密码是否合法
    private func isAccountOrPasswordLegal() -> Bool {
        return accountTextField.text?.count ?? 0 > 5 && passwordTextField.text?.count ?? 0 > 5
    }
    
    // 设置loginButton按钮状态
    private func enableLoginButton(enable:Bool) {
        loginButton.alpha = enable ? 1 : 0.4
        loginButton.isEnabled = enable
    }
}
