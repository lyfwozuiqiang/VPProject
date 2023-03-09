//
//  VPSelectLanguageController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/6.
//  选择语言控制器

import UIKit

class VPSelectLanguageController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    private let languageTableView:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(VPLanguageItemCell.self, forCellReuseIdentifier: "VPLanguageItemCell")
        return tableView
    }()
    
    private var languageArray:Array<LanguageInfo> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // 布局用户页面
        layoutUserInterface()
        // 获取并处理语言选项
        dealLanguagesData()
    }
    
    deinit {
        print("VPSelectLanguageController deinit")
    }
    
    // MARK: —— Network
    private func getLanguageRequest() async -> LangeuageResponse? {
        let bundleFileUrl = Bundle.main.url(forResource: "LanguageSelectData", withExtension: "json")
        guard let fileUrl = bundleFileUrl else {
            return nil
        }
        if let jsonData = try? Data(contentsOf: fileUrl) {
            let languageInfo = try? JSONDecoder().decode(LangeuageResponse.self, from: jsonData)
            return languageInfo
        } else {
            return nil
        }
    }
    
    private func dealLanguagesData() {
        Task {
            let response = await getLanguageRequest()
            languageArray = response?.data ?? []
            if languageArray.count > 0 {
                var firstLanguageInfo = languageArray.first
                firstLanguageInfo?.isSelected = true
                languageArray[0] = firstLanguageInfo!
                languageTableView.reloadData()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    if self.view.window != nil {
                        let alertController = UIAlertController(title: "", message: "Oops! Data is lost. Please try again later.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Retry", style: .default) { _ in
                            self.dealLanguagesData()
                        }
                        alertController.addAction(action)
                        self.present(alertController, animated: true)
                    }
                })
            }
        }
    }
    
    // MARK: —— Action
    // 返回按钮点击事件
    @objc private func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonClick() {
        print("VPSelectLanguageController nextButtonClick")
    }
    
    // MARK: —— UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VPLanguageItemCell") as! VPLanguageItemCell
        cell.languageInfo = languageArray[indexPath.row]
        return cell
    }
    
    // MARK: —— UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if languageArray[indexPath.row].isSelected { return }
        for index in 0..<languageArray.count {
            var model = languageArray[index]
            if index == indexPath.row {
                model.isSelected = true
            } else {
                model.isSelected = false
            }
            languageArray[index] = model
        }
        tableView.reloadData()
    }
    
    // MARK: —— Private method
    private func layoutUserInterface() {
        // 添加背景图片
        let bgImageView:UIImageView = UIImageView(image: UIImage(named: "login_regist_bg_image"))
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 添加返回按钮
        let backButton:UIButton = UIButton.init(type: .system)
        let backImage:UIImage? = UIImage(named: "login_regist_back_icon")?.withRenderingMode(.alwaysOriginal)
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        let selectLanguageLabel:UILabel = UILabel.init()
        selectLanguageLabel.text = "Select your native language"
        selectLanguageLabel.textColor = .white
        selectLanguageLabel.font = UIFont.russoOneFont(ofSize: 20)
        view.addSubview(selectLanguageLabel)
        selectLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        let lineView:VPGradientView = VPGradientView.init()
        lineView.backgroundColors = [UIColor(hex6: 0x4F6EF4, alpha: 0).cgColor,UIColor(hex6: 0x4F6EF4).cgColor,UIColor(hex6: 0x4F6EF4, alpha: 0).cgColor]
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(240)
            make.top.equalTo(selectLanguageLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        let nextButton:UICommonButton = UICommonButton(style: .gradientPurple)
        nextButton.updateTitle("Next")
        nextButton.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
            make.bottom.equalTo(view.snp.bottom).offset(-82)
            make.height.equalTo(48)
        }
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        view.addSubview(languageTableView)
        languageTableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(view.snp.right)
            make.top.equalTo(lineView).offset(50)
            make.bottom.equalTo(nextButton.snp.top).offset(-50)
        }
    }
}
