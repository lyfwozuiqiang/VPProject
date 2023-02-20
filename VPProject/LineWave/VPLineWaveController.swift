//
//  VPLineWaveController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/20.
//

import UIKit

class VPLineWaveController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let lineWaveView = VPLineWaveView.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        lineWaveView.backgroundColor = .cyan
        view.addSubview(lineWaveView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            lineWaveView.invalidateDisplayLink()
            lineWaveView.removeFromSuperview()
        })
    }

}
