//
//  VPDialogueView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/19.
//

import UIKit

class VPDialogueView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    var title:String? {
        didSet {
            titleLabel.text = title
            topGradientView.isHidden = !(title != nil && title!.count > 0)
        }
    }
    
    var dialogueArray:Array<String> = []

    private let topGradientView:VPGradientView = {
        let gradientView = VPGradientView.init()
        gradientView.gradientLineHeight = 2
        let lineColor = UIColor(red: 0.33, green: 0.84, blue: 1.0, alpha: 1)
        gradientView.topBottomLineColors = [lineColor.withAlphaComponent(0).cgColor,lineColor.cgColor,lineColor.withAlphaComponent(0).cgColor]
        let backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.11, alpha: 1)
        gradientView.backgroundColors = [backgroundColor.withAlphaComponent(0.1).cgColor,backgroundColor.withAlphaComponent(0.8).cgColor,backgroundColor.withAlphaComponent(0.1).cgColor]
        gradientView.isHidden = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(red: 0.28, green: 0.7, blue: 1, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dialogueTableView:UITableView = {
        let tableView = UITableView.init(frame: CGRectZero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        tableView.register(VPDialogueLeftCell.self, forCellReuseIdentifier: "VPDialogueLeftCell")
        tableView.register(VPDialogueRightCell.self, forCellReuseIdentifier: "VPDialogueRightCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 65).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -65).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        insertSubview(topGradientView, belowSubview: titleLabel)
        topGradientView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -20).isActive = true
        topGradientView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20).isActive = true
        topGradientView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12).isActive = true
        topGradientView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        
        addSubview(dialogueTableView)
        dialogueTableView.dataSource = self
        dialogueTableView.delegate = self
        dialogueTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dialogueTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dialogueTableView.topAnchor.constraint(equalTo: topGradientView.bottomAnchor, constant: 20).isActive = true
        dialogueTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: —— UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return dialogueArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section % 2 == 0 {
            let leftCell = tableView.dequeueReusableCell(withIdentifier: "VPDialogueLeftCell") as! VPDialogueLeftCell
            leftCell.dialogueString = dialogueArray[indexPath.section]
            return leftCell
        } else {
            let rightCell = tableView.dequeueReusableCell(withIdentifier: "VPDialogueRightCell") as! VPDialogueRightCell
            rightCell.dialogueString = dialogueArray[indexPath.section]
            return rightCell
        }
    }
    
    //MARK: —— UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath,indexPath",indexPath,indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearView = UIView.init()
        return clearView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 32
        } else {
            return 16
        }
    }
}
