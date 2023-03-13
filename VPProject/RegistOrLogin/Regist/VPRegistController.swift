//
//  VPRegistController.swift
//  VPProject
//
//  Created by 刘伟 on 2023/3/8.
//

import UIKit

class VPRegistController: UIViewController,UITableViewDataSource,UITableViewDelegate,VPRightAnswerCellDelegate {
  
  private let borderView:VPPolygonBorderView = {
    let borderView = VPPolygonBorderView.init()
    borderView.borderEndPoint = CGPoint(x: 1, y: 0)
    borderView.borderWidth = 1
    borderView.borderColors = [UIColor(hex6: 0xE64BFA).cgColor,UIColor(hex6: 0x0569FF).cgColor,UIColor(hex6: 0x6FCCFF).cgColor]
    return borderView
  }()
  
  private let registTableView:UITableView = {
    let tableView = UITableView.init(frame: CGRectZero, style: .grouped)
    tableView.showsVerticalScrollIndicator = false
    tableView.showsHorizontalScrollIndicator = false
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.keyboardDismissMode = .onDrag
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    tableView.register(VPLeftConversationCell.self, forCellReuseIdentifier: "VPLeftConversationCell")
    tableView.register(VPRightAnswerCell.self, forCellReuseIdentifier: "VPRightAnswerCell")
    return tableView
  }()
  
  private let gradientLayer:CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.anchorPoint = CGPoint.zero
    layer.startPoint = CGPoint.zero
    layer.endPoint = CGPoint(x: 1, y: 0)
    layer.colors = [UIColor(hex6: 0xF54EF9).cgColor,UIColor(hex6: 0x6631FF).cgColor,UIColor(hex6: 0x6FD0FF).cgColor]
    layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 256, height: 8))
    return layer
  }()
  
  private let line1View:UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(hex6: 0x111F4A)
    view.isHidden = true
    return view
  }()
  
  private let line2View:UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(hex6: 0x111F4A)
    view.isHidden = true
    return view
  }()
  
  private let line3View:UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(hex6: 0x111F4A)
    view.isHidden = true
    return view
  }()
  
  private var isExcuteAnimation2 = false,isExcuteAnimation3 = false,isExcuteAnimation4 = false
  
  private var originResponse:QuestionResponse?
  private var currentDialog:[Question] = []
  private var timer:Timer?
  
  // MARK: —— Lift cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    // 布局用户页面
    layoutUserInterface()
    // 获取并处理对白数据
    dealDialogData()
  }
  
  deinit {
    print("VPRegistController deinit")
  }
  
  // MARK: —— Action
  // 返回按钮点击事件
  @objc private func backButtonClick() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func timerAcion() {
    for (index,item) in currentDialog.enumerated() {
      if !item.isShowFinished {
        var currentConversation = currentDialog[index]
        if currentConversation.items?.count ?? 0 >= originResponse?.data?[index].items?.count ?? 0 && index == originResponse?.data?.count {
          return
        }
        if currentConversation.targetDefinition == nil {
          var currenetItems = currentConversation.items
          if currenetItems?.count == originResponse?.data?[index].items?.count {
            currentConversation.isShowFinished = true
            currentDialog[index] = currentConversation
            if currentDialog.count < originResponse?.data?.count ?? 0 {
              var newSectionItem = originResponse?.data?[index + 1]
              while newSectionItem?.items?.count ?? 0 > 1 {
                newSectionItem?.items?.removeLast()
              }
              if newSectionItem != nil {
                currentDialog.append(newSectionItem!)
              }
            }
            timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
              self.timerAcion()
            })
          } else {
            guard let nextIndex = currentConversation.items?.count else { return }
            let nextItem = originResponse?.data?[index].items?[nextIndex]
            
            if nextItem != nil {
              currenetItems?.append(nextItem!)
            }
            currentDialog[index].items = currenetItems
            let indexSet = IndexSet(integer: index)
            registTableView.reloadSections(indexSet, with: .automatic)
            let indexPath = IndexPath(item: nextIndex, section: index)
            registTableView.scrollToRow(at: indexPath, at: .none, animated: true)
          }
          break
        } else {
          let questionItems = originResponse?.data?[index].items
          if questionItems != nil {
            currentDialog[index].items = questionItems
            let indexSet = IndexSet(integer: index)
            registTableView.reloadSections(indexSet, with: .automatic)
            let indexPath = IndexPath(item: (questionItems?.count)! - 1, section: index)
            registTableView.scrollToRow(at: indexPath, at: .none, animated: true)
          }
          break
        }
      }
    }
  }
  
  // MARK: —— UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return currentDialog.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentDialog[section].items?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = currentDialog[indexPath.section]
    if item.targetDefinition == nil {
      let cell = tableView.dequeueReusableCell(withIdentifier: "VPLeftConversationCell") as! VPLeftConversationCell
      cell.questionItem = currentDialog[indexPath.section].items?[indexPath.row]
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "VPRightAnswerCell") as! VPRightAnswerCell
      cell.delegate = self
      cell.isExpandStatus = item.isExpand
      cell.rowIndex = indexPath.row
      cell.questionItem = currentDialog[indexPath.section].items?[indexPath.row]
      return cell
    }
  }
  
  // MARK: —— UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if currentDialog[indexPath.section].targetDefinition == nil { return }
    if !currentDialog[indexPath.section].isExpand { return}
    if var items = currentDialog[indexPath.section].items {
      for index in 0..<items.count {
        var item = items[indexPath.row]
        item.isSelected = index == indexPath.row
        items[index] = item
        if indexPath.row == index {
          currentDialog[indexPath.section].items = [item]
        }
      }
      var item = currentDialog[indexPath.section]
      item.isExpand = false
      item.isShowFinished = true
      currentDialog[indexPath.section] = item
      tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableView.RowAnimation.automatic)
      
      if self.currentDialog[indexPath.section].type == "WXCODE" {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
          if indexPath.row == 0 {
            self.addNoCodeMessage()
          } else {
            self.addHaveCodeMessage()
          }
        })
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        self.timerAcion()
        if !self.isExcuteAnimation2 &&  self.currentDialog[indexPath.section].type == "PURPOSE" {
          self.isExcuteAnimation2 = true
          self.gradientLayerAnimation(fromValue: 1/4, toValue: 1/2)
          self.line1View.isHidden = false
        }
        
        if !self.isExcuteAnimation3 && self.currentDialog[indexPath.section].type == "LEVEL"{
          self.isExcuteAnimation3 = true
          self.gradientLayerAnimation(fromValue: 1/2, toValue: 3/4)
          self.line2View.isHidden = false
        }
      })
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let question = currentDialog[section]
    if question.targetDefinition != nil && question.items?.count ?? 0 > 0 {
      
      if question.isExpand {
        let headerView = VPQuestionHeaderView.init()
        headerView.titleText = "T-Rex"
        if question.type == "PURPOSE" || question.type == "LEVEL" || question.type == "WXCODE" {
          headerView.indicatorText = "·Select your answer :"
        } else {
          headerView.indicatorText = "·Please enter..."
        }
        headerView.dialogText = question.targetDefinition
        return headerView
      } else {
        let conversationView = VPLeftConversationView.init()
        conversationView.titleText = "T-Rex"
        conversationView.dialogText = question.targetDefinition
        return conversationView
      }
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let question = currentDialog[section]
    if question.targetDefinition != nil && question.items?.count ?? 0 > 0 {
      return UITableView.automaticDimension
    }
    return 0
  }
  
  // MARK: —— VPRightAnswerCellDelegate
  func expandButtonClick(at cell: VPRightAnswerCell) {
    let indexPath = registTableView.indexPath(for: cell)
    let originItems = originResponse?.data?[indexPath!.section].items
    let selectedItem = currentDialog[indexPath!.section].items?.first
    var expands:Array<QuestionItem> = [QuestionItem]()
    for var item in originItems! {
      if item == selectedItem {
        item.isSelected = true
      } else {
        item.isSelected = false
      }
      expands.append(item)
    }
    currentDialog[indexPath!.section].isExpand = true
    currentDialog[indexPath!.section].items = expands
    registTableView.reloadSections(IndexSet(integer: indexPath!.section), with: .automatic)
  }
  
  // MARK: —— Network
  private func getGreetingWordsRequest() async -> QuestionResponse? {
    guard let fileUrl = Bundle.main.url(forResource: "RegistData", withExtension: "json") else {
      return nil
    }
    if let jsonData = try? Data(contentsOf: fileUrl) {
      let response = try? JSONDecoder().decode(QuestionResponse.self, from: jsonData)
      return response
    } else {
      return nil
    }
  }
  
  private func dealDialogData() {
    Task {
      var response = await getGreetingWordsRequest()
      let wxQuestion = Question(type: "WXCODE", targetDefinition: "Rất tốt. Bạn có mã mời của ứng dụng này không?",items: [QuestionItem(qosCode: nil, targetDefinition: "Vâng, tôi có.", englishDefinition: nil),QuestionItem(qosCode: nil, targetDefinition: "Không, tôi không có.", englishDefinition: nil)], isShowFinished: false, isExpand: true)
      response?.data?.append(wxQuestion)
      
      let lastQuestion = Question(type: "REGIST", targetDefinition: "Rất tốt, hãy tạo ra một tài khoản và hoàn thành đăng ký nhé.",items: nil, isShowFinished: false, isExpand: true)
      response?.data?.append(lastQuestion)
      
      self.originResponse = response
      if response?.data?.count ?? 0 > 0 {
        timer?.invalidate()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerAcion), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        gradientLayerAnimation(fromValue: 0, toValue: 1/4)
        for index in 0..<(response?.data?.count ?? 0) {
          if let question = response?.data?[index] {
            currentDialog.append(question)
            if index == 0 {
              if currentDialog[index].items?.count ?? 0 > 1 {
                let item = currentDialog.first?.items?[0]
                currentDialog[index].items = [item!]
              }
            } else {
              currentDialog[index].items = []
            }
          }
        }
        registTableView.reloadData()
      } else {
        let alertController = UIAlertController(title: "", message: "Oops! Data is lost. Please try again later.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .default) { _ in
          self.dealDialogData()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
      }
    }
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
    let backImage:UIImage? = UIImage(named: "guide_back_arrow_icon")?.withRenderingMode(.alwaysOriginal)
    backButton.setImage(backImage, for: .normal)
    backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
    view.addSubview(backButton)
    backButton.snp.makeConstraints { make in
      make.top.equalTo(view.snp.topMargin)
      make.left.equalToSuperview().offset(16)
      make.size.equalTo(44)
    }
    
    // 添加渐变边框
    view.addSubview(borderView)
    borderView.snp.makeConstraints { make in
      make.left.equalTo(backButton.snp.right).offset(10)
      make.height.equalTo(12)
      make.right.equalTo(view.snp.right).offset(-64)
      make.centerY.equalTo(backButton.snp.centerY)
    }
    
    let layerContainerView = UIView()
    view.backgroundColor = .clear
    view.addSubview(layerContainerView)
    layerContainerView.snp.makeConstraints { make in
      make.left.equalTo(backButton.snp.right).offset(12)
      make.height.equalTo(8)
      make.right.equalTo(view.snp.right).offset(-65)
      make.centerY.equalTo(backButton.snp.centerY)
    }
    layerContainerView.layer.addSublayer(gradientLayer)
    
    layerContainerView.addSubview(line1View)
    line1View.snp.makeConstraints { make in
      make.width.equalTo(1)
      make.top.equalTo(borderView).offset(2)
      make.bottom.equalTo(borderView).offset(-2)
      make.centerX.equalTo(borderView).multipliedBy(0.66)
    }
    
    layerContainerView.addSubview(line2View)
    line2View.snp.makeConstraints { make in
      make.width.equalTo(1)
      make.top.equalTo(borderView).offset(2)
      make.bottom.equalTo(borderView).offset(-2)
      make.centerX.equalTo(borderView).multipliedBy(1)
    }
    
    layerContainerView.addSubview(line3View)
    line3View.snp.makeConstraints { make in
      make.width.equalTo(1)
      make.top.equalTo(borderView).offset(2)
      make.bottom.equalTo(borderView).offset(-2)
      make.centerX.equalTo(borderView).multipliedBy(1.33)
    }
    
    registTableView.delegate = self
    registTableView.dataSource = self
    view.addSubview(registTableView)
    registTableView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(backButton.snp.bottom).offset(26)
    }
  }
  
  private func gradientLayerAnimation(fromValue:CGFloat,toValue:CGFloat) {
    let width = UIScreen.main.bounds.size.width - 72 - 67
    let fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: width * fromValue, height: 8))
    let toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: width * toValue, height: 8))
    let basicAnimation = CABasicAnimation(keyPath: "bounds")
    
    basicAnimation.duration = 1
    basicAnimation.fromValue = fromValue
    basicAnimation.toValue = toValue
    basicAnimation.fillMode = .forwards
    basicAnimation.isRemovedOnCompletion = false
    gradientLayer.add(basicAnimation, forKey: nil)
  }
  
  private func addNoCodeMessage() {
    let footerView = VPLeftConversationView()
    footerView.attributeText = "Xin lỗi, hiện tại chúng tôi không thể hỗ trợ đăng ký nếu bạn không có mã mời. Bạn có thể tham gia vào nhóm để nhận được cơ hội trải nghiệm sớm.\nhttps://discord.gg/raJvkrx84A"
    footerView.titleText = "T-Rex"
    footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 250)
    registTableView.tableFooterView = footerView
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
      self.registTableView.scrollRectToVisible(CGRect(x: 0, y: self.registTableView.tableFooterView!.frame.origin.y, width: 1, height:250), animated: true)
    })
  }
  
  private func addHaveCodeMessage() {
    let footerView = VPTableFooterView()
    footerView.backgroundColor = .clear
    footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 500)
    registTableView.tableFooterView = footerView
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
      self.registTableView.scrollRectToVisible(CGRect(x: 0, y: self.registTableView.tableFooterView!.frame.origin.y, width: 1, height:500), animated: true)
    })
  }
}
