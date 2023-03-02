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
    var index:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        lineWaveView = VPLineWaveView.init()
        view.addSubview(lineWaveView!)
        lineWaveView?.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.topMargin).offset(100)
            make.height.equalTo(100)
        })
        self.lineWaveView?.amplitude = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.excuteLineAnimation()
        })
    }
    
    func excuteLineAnimation() {
        if index < 200 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [self] in
                index += 1
                let random = arc4random_uniform(120)
                print(index,random)
                self.lineWaveView?.amplitude = Double(random)
                self.excuteLineAnimation()
            })
        }
    }
    
    deinit {
        print("VPLineWaveController deinit")
    }
}
