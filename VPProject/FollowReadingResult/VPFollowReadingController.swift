//
//  VPFollowReadingController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/28.
//

import UIKit

class VPFollowReadingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.init(type: .contactAdd)
        button.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(button)

    }
    
    @objc func buttonClick() {
        let model = FollowReadingViewModel.init(title: "Try again", message: "Come on...You can do better !", titleColor: UIColor(hex6: 0x4EF8BB), messageColor: UIColor(hex6: 0x3EF0AB), lefCubeColors: [UIColor(hex6: 0x55EBFF).cgColor,UIColor(hex6: 0x55EBFF, alpha: 0).cgColor], titleBgColors: [UIColor(hex6: 0x315EFF).cgColor,UIColor(hex6: 0x315EFF,alpha: 0).cgColor], messageBgColor: [UIColor(hex6: 0x315EFF,alpha: 0.8).cgColor,UIColor(hex6: 0x315EFF,alpha: 0).cgColor])
        let followView = VPFollowReadingResultView.init(with: model)
        followView.backgroundColor = .purple
        view.addSubview(followView)
        followView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(200)
            make.height.equalTo(300)
        }
        followView.excuteAnimation()
    }
}
