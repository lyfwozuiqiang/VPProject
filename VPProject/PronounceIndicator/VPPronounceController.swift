//
//  VPPronounceController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/24.
//

import UIKit

class VPPronounceController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton(type: .detailDisclosure)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(button)
    }
     
    @objc func buttonClick() {
        let model = PronounceViewModel.init(containerSide:.left(space:30),containerPosition:.bottom(CGPoint(x: 177.0, y: 585)), isShowTriangle: true, americanAccent: nil, britishAccent: "英/ˈmɔːnɪŋ/", translateContent: nil)
        let pronounceView = VPPronounceView.init(with: model)
        view.addSubview(pronounceView)
        pronounceView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
