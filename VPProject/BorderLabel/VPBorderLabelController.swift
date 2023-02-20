//
//  VPBorderLabelController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/17.
//

import UIKit

class VPBorderLabelController: UIViewController {
    
    var viewLeadingConstraint:NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let borderLabel = VPBorderLabel.init()
        borderLabel.numberOfLines = 2;
        borderLabel.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(borderLabel)
        viewLeadingConstraint = borderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100)
        viewLeadingConstraint?.isActive = true;
        borderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        borderLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        borderLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        let attributeStr = NSMutableAttributedString.init(string:"hello wossrld hello world")
        attributeStr.addAttributes([.strikethroughStyle: NSUnderlineStyle.thick.rawValue,.strikethroughColor:UIColor.blue], range: NSRange(location: 5, length: 15))
        borderLabel.attributedText = attributeStr
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            borderLabel.isShowBorder = true
            borderLabel.borderWidth = 2
            borderLabel.borderColor = UIColor.green
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                borderLabel.borderWidth = 4
                borderLabel.borderColor = UIColor.red
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.viewLeadingConstraint?.constant = 110
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        borderLabel.isShowBorder = false
                    })
                })
            })
        })
    }
}
