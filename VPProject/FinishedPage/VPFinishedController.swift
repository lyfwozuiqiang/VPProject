//
//  VPFinishedController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/21.
//

import UIKit

import SnapKit

class VPFinishedController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let redButton = UIButton.init(frame: CGRect(x: 50, y: 150, width: 100, height: 100))
        redButton.backgroundColor = .red
        redButton.setTitle("按钮", for: .normal)
        redButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(redButton)        
    }
    
    @objc func buttonClick() {
        let finishView = VPFinishedView.init(level: .levelNormal)
        finishView.levelText = "Perfect Complete"
        finishView.coinCount = 1238
        view.addSubview(finishView)
        finishView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}
