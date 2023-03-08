//
//  VPItemCell.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/18.
//

import UIKit

class VPItemCell: UITableViewCell {

    var itemTitle:String = "" {
        didSet {
            titleLabel.text = itemTitle
        }
    }
    
    private let gradientView:VPGradientView = {
        let view = VPGradientView.init()
        view.gradientLineHeight = 1
        let borderColor = UIColor(red: 0.33, green: 0.84, blue: 1, alpha: 1)
        view.topBottomLineColors = [borderColor.withAlphaComponent(0.1).cgColor,borderColor.cgColor,borderColor.withAlphaComponent(0.1).cgColor]
        let customBlueColor = UIColor(red: 0.31, green: 0.43, blue: 0.96, alpha: 1)
        view.backgroundColors = [customBlueColor.withAlphaComponent(0.03).cgColor,customBlueColor.withAlphaComponent(1).cgColor,customBlueColor.withAlphaComponent(0.03).cgColor]
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.montserratMediumFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: —— Override
    override var isSelected: Bool {
        didSet {
            gradientView.isHidden = !isSelected
        }
    }
    
    // MARK: —— View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(gradientView)
        gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
