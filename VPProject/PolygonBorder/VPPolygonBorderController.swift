//
//  VPPolygonBorderController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/23.
//

import UIKit

class VPPolygonBorderController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let borderView = VPPolygonBorderView.init(frame: CGRect(x: 100, y: 200, width: 200, height: 46))
        borderView.topSpaces = (CGPoint(x: 20, y: 0),CGPoint(x: 0, y: 0))
        borderView.rightSpaces = (CGPoint(x: 0, y: 0),CGPoint(x: 5, y: 0))
        borderView.bottomSpaces = (CGPoint(x: 0, y: 0),CGPoint(x: 5, y: 0))
        borderView.leftSpaces = (CGPoint(x: 5, y: 10),CGPoint(x: 0, y: 0))
        borderView.backgroundEndPoint = CGPoint(x: 1, y: 0)
        borderView.shortCubeColor = UIColor.yellow.cgColor
        borderView.borderColors = [UIColor.red.cgColor,UIColor.orange.cgColor]
        borderView.backgroundColors = [UIColor.green.cgColor,UIColor.green.withAlphaComponent(0.3).cgColor]
        borderView.borderWidth = 2
        view.addSubview(borderView)
        
        let borderView2 = VPPolygonBorderView.init(frame: CGRect(x: 100, y: 300, width: 200, height: 280))
        borderView2.topSpaces = (CGPoint(x: 20, y: 0),CGPoint(x: 0, y: 0))
        borderView2.rightSpaces = (CGPoint(x: 0, y: 0),CGPoint(x: 2, y: 20))
        borderView2.bottomSpaces = (CGPoint(x: 0, y: 0),CGPoint(x: 10, y: 0))
        borderView2.leftSpaces = (CGPoint(x: 20, y: 0),CGPoint(x: 0, y: 0))
        borderView2.backgroundEndPoint = CGPoint(x: 1, y: 1)
        borderView2.borderColors = [UIColor.red.cgColor]
        borderView2.shortCubeColor = UIColor.yellow.cgColor
        borderView2.backgroundColors = [UIColor.green.cgColor,UIColor.blue.cgColor]
        borderView2.borderWidth = 4
        view.addSubview(borderView2)
    }
}
