//
//  VPRegistController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/8.
//

import UIKit

class VPRegistController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        //布局用户页面
        layoutUserInterface()
    }
    
    // MARK: —— Action
    // 返回按钮点击事件
    @objc private func backButtonClick() {
        navigationController?.popViewController(animated: true)
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
        
        // 添加返回按钮
        let backButton:UIButton = UIButton.init(type: .system)
        let backImage:UIImage? = UIImage(named: "guide_back_arrow_icon")?.withRenderingMode(.alwaysOriginal)
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
    }
}
