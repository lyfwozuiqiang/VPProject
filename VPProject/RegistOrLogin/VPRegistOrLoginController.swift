//
//  VPRegistOrLoginController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/3.
//

import UIKit

class VPRegistOrLoginController: UIViewController {
    
    // MARK: —— Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // 布局用户页面
        layoutUserInterface()
    }
    
    // MARK: —— Action
    // 注册按钮点击事件
    @objc func signUpButtonClick() {
        let selectLanguageVc = VPSelectLanguageController.init()
        navigationController?.pushViewController(selectLanguageVc, animated: true)
    }
    
    // 登录按钮点击事件
    @objc func loginButtonClick() {
        let loginVc = VPLoginController.init()
        navigationController?.pushViewController(loginVc, animated: true)
    }
    
    // MARK: —— Private method
    private func layoutUserInterface() {
        // 添加背景图片
        let bgImageView:UIImageView = UIImageView(image: UIImage(named: "login_regist_bg_image"))
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let label:UILabel = UILabel.init()
        label.font = UIFont.montserratRegularFont(ofSize: 16)
        label.text = "Master a language, Mastar the way!"
        label.textAlignment = .center
        label.textColor = .white
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.left.equalToSuperview().offset(24)
            make.right.equalTo(view.snp.right).offset(-24)
        }
        
        let logoImageView = UIImageView(image: UIImage(named: "launch_logo"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.bottom.equalTo(label.snp.top).offset(-20)
            make.centerX.equalTo(view)
        }
        
        let dragonImageView:UIImageView = UIImageView(image: UIImage(named: "login_regist_dragon_image"))
        dragonImageView.contentMode = .scaleAspectFill
        view.addSubview(dragonImageView)
        dragonImageView.snp.makeConstraints { make in
            make.bottom.equalTo(logoImageView.snp.top).offset(-50)
            make.size.equalTo(190)
            make.centerX.equalTo(view)
        }
        
        // 添加注册按钮
        let signUpButton:UICommonButton = UICommonButton.init(style: .gradientPurple)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.montserratRegularFont(ofSize: 16)
        signUpButton.addTarget(self, action: #selector(signUpButtonClick), for: .touchUpInside)
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
            make.height.equalTo(48)
            make.top.equalTo(label.snp.bottom).offset(104)
        }
        
        // 添加登录按钮
        let loginButton:UIButton = UIButton(type: .custom)
        loginButton.backgroundColor = UIColor(hex6: 0x262448)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.layer.cornerRadius = 24
        loginButton.titleLabel?.font = UIFont.montserratRegularFont(ofSize: 16)
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
            make.height.equalTo(48)
            make.top.equalTo(signUpButton.snp.bottom).offset(24)
        }
    }
}
