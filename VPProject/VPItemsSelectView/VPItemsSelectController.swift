//
//  VPItemsSelectController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/17.
//

import UIKit

class VPItemsSelectController: UIViewController {
    
    var clickIndex:Int = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
                
        let redView = UIView.init(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        redView.backgroundColor = .red
        view.addSubview(redView)
        
        let blueView = UIView.init(frame: CGRect(x: 300, y: 200, width: 100, height: 100))
        blueView.backgroundColor = .blue
        view.addSubview(blueView)
        
        let cyanButton = UIButton.init(type: .system)
        cyanButton.backgroundColor = UIColor.cyan
        cyanButton.setTitle("按钮", for: .normal)
        cyanButton.frame = CGRectMake(100, 400, 60, 60)
        cyanButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(cyanButton)
    }
    
    @objc func buttonClick() {
        guard let naviView = navigationController?.view else {
            return
        }
        
        var itemsView:VPItemsSelectView
        if clickIndex % 2 == 0 {
            itemsView = VPItemsSelectView.init(title: "Text", itemsArray: ["English","English - Tiếng Việt","không ai"],selectedIndex: 1)
        } else {
            itemsView = VPItemsSelectView.init(title: "Rate", itemsArray: ["1.5x","1.25x","1.0x","0.75x","0.5x"])
        }
        clickIndex += 1
        itemsView.confirmHandle = {(index,value) in
            print("点击了\(index) value = \(value)")
        }
        itemsView.translatesAutoresizingMaskIntoConstraints = false
        naviView.addSubview(itemsView)
        itemsView.leadingAnchor.constraint(equalTo: naviView.leadingAnchor).isActive = true
        itemsView.trailingAnchor.constraint(equalTo: naviView.trailingAnchor).isActive = true
        itemsView.topAnchor.constraint(equalTo: naviView.topAnchor).isActive = true
        itemsView.bottomAnchor.constraint(equalTo: naviView.bottomAnchor).isActive = true
    }
}
