//
//  VPItemsSelectView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/16.
//

import UIKit

class VPItemsSelectView: UIView,UITableViewDataSource,UITableViewDelegate {

    var title:String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    /// Cell标题
    var itemsArray:Array<String> = []
    /// Cell选中状态
    private var itemSelectStatusArray:Array<Bool> = []
    /// 确认按钮点击回调
    var confirmHandle:((_ index:Int,_ value:String) -> Void)?
    
    static private let kSpaceLength:Double = 30
    
    private let borderView:VPBorderView = {
        let borderView = VPBorderView.init()
        borderView.borderWidth = 2
        borderView.leftSpaces.top = VPItemsSelectView.kSpaceLength
        borderView.topSpacess.left = VPItemsSelectView.kSpaceLength
        borderView.rightSpaces.bottom = VPItemsSelectView.kSpaceLength
        borderView.bottomSpaces.right = VPItemsSelectView.kSpaceLength
        borderView.borderColors = [UIColor.init(red: 0.31, green: 0.43, blue: 0.96, alpha: 1).cgColor,UIColor.init(red: 0.4, green: 0.19, blue: 1.0, alpha: 1).cgColor]
        borderView.translatesAutoresizingMaskIntoConstraints = false
        return borderView
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemsTableView:UITableView = {
        let tableView = UITableView.init(frame: CGRectZero, style: UITableView.Style.plain)
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let confirmButton:UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("OK", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: —— View life cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("\n\r\tVPItemsSelectView deinit\n")
    }
    
    init(title: String, itemsArray: Array<String> = [],selectedIndex:Int? = -1) {
        self.title = title
        self.itemsArray = itemsArray
        super.init(frame: CGRectZero)
        
        itemSelectStatusArray = Array(repeating: false, count: itemsArray.count)
        if (selectedIndex != nil && selectedIndex! >= 0 && selectedIndex! < itemsArray.count) {
            itemSelectStatusArray[selectedIndex!] = true
        }
        
        alpha = 0.3
        // 添加模糊背景
        addVisualEffectView()
        // 添加渐变色边框View
        addBorderView()
        // 添加标题Label
        addTitleLabel()
        // 添加渐变色横线View
        addLineGradientView()
        // 添加、设置选项TableView
        addItemsTableView()
        // 添加确认按钮
        addConfirmButton()
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }
    
    //MARK: —— UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VPItemCell") as! VPItemCell
        cell.itemTitle = itemsArray[indexPath.row]
        cell.isSelected = itemSelectStatusArray[indexPath.row]
        return cell
    }
    
    //MARK: —— UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0..<itemSelectStatusArray.count {
            itemSelectStatusArray[index] = false
        }
        itemSelectStatusArray[indexPath.row] = true
        tableView.reloadData()
    }
    
    //MARK: —— Action
    @objc func confirmButtonClick() {
        var resultIndex = -1
        for (index,value) in itemSelectStatusArray.enumerated() {
            if value == true {
                resultIndex = index
                break
            }
        }
        if resultIndex != -1 {
            let value = self.itemsArray[resultIndex]
            removeSelf()
            confirmHandle?(resultIndex,value)
        }
    }
    
    //MARK: —— Private method
    private func addVisualEffectView() {
        let visualEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let visualEffectView = UIVisualEffectView.init(effect: visualEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addBorderView() {
        addSubview(borderView)
        borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        borderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        let borderViewHeight:CGFloat = 60 + 1 + CGFloat(itemsArray.count * 44) + 36 + 48 + 36
        borderView.heightAnchor.constraint(equalToConstant: borderViewHeight).isActive = true
    }
    
    private func addTitleLabel() {
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: Self.kSpaceLength).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -Self.kSpaceLength).isActive = true
        titleLabel.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func addLineGradientView() {
        let gradientView = VPGradientView.init()
        let customBlueColor = UIColor(red: 0.31, green: 0.43, blue: 0.96, alpha: 1)
        gradientView.backgroundColors = [customBlueColor.withAlphaComponent(0.03).cgColor,customBlueColor.withAlphaComponent(1).cgColor,customBlueColor.withAlphaComponent(0.03).cgColor,]
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientView)
        gradientView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 16).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16).isActive = true
        gradientView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func addItemsTableView() {
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.register(VPItemCell.self, forCellReuseIdentifier: "VPItemCell")
        addSubview(itemsTableView)
        itemsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        itemsTableView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 28).isActive = true
        itemsTableView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -28).isActive = true
        itemsTableView.heightAnchor.constraint(equalToConstant: CGFloat(itemsArray.count * 44)).isActive = true
    }
    
    private func addConfirmButton() {
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        addSubview(confirmButton)
        confirmButton.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 24).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -24).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -36).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func removeSelf() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { isFinished in
            if isFinished {
                self.removeFromSuperview()
            }
        }
    }
}
