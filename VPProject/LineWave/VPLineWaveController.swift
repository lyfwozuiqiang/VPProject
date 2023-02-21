//
//  VPLineWaveController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/20.
//

import UIKit

import SnapKit

class VPLineWaveController: UIViewController {

    private var lineWaveView:VPLineWaveView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        lineWaveView = VPLineWaveView.init()
        lineWaveView?.amplitude = 40
        lineWaveView?.enableWaveAnimation(enable: true)
        view.addSubview(lineWaveView!)
        lineWaveView?.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(view.snp.topMargin).offset(100)
            make.height.equalTo(100)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.lineWaveView?.amplitude = 10
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.lineWaveView?.amplitude = 30
            })
        })
    }
    
    deinit {
        print("VPLineWaveController deinit")
        lineWaveView?.invalidateDisplayLink()
    }
}
