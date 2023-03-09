//
//  AlertPopupManager.swift
//  Mastar
//
//  Created by Zacharyah on 2023/2/20.
//

import Foundation
import UIKit
import SWUIKit
import Then
import SnapKit

// MARK: AlertRootViewController
class AlertRootViewController: UIBlurBaseViewController {

  let statusBarStyle: UIStatusBarStyle
  init(statusBarStyle: UIStatusBarStyle) {
    self.statusBarStyle = statusBarStyle
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var shouldAutorotate: Bool {
    false
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    statusBarStyle
  }
  

}

// MARK: AlertPopupManager

public let AlertManager = AlertPopupManager.default

public class AlertPopupManager {
  
  fileprivate static let `default` = AlertPopupManager()
  
  fileprivate let window = UIWindow(frame: UIScreen.main.bounds).then {
    $0.backgroundColor = .clear
    $0.windowLevel = .alert + 1
  }
      
  fileprivate var alertView: UIAlertPopupView?
  
  fileprivate let mascotTipsView = MascotTipsView().then {
    $0.update(tips: .calling)
  }
  
  public func dismissWithAction(_ action: (() -> Void)? = nil ) {
    UIView.animate(withDuration: 0.25, animations: {
      self.alertView?.alpha = 0
      self.window.alpha = 0
    }) { flag in
      self.window.isHidden = true
      self.alertView?.removeFromSuperview()
      self.alertView = nil
      action?()
    }
  }
  
  public func show(_ viewModel: AlertViewModel, confirmAction: @escaping () -> Void, destructiveAction: @escaping () -> Void) {
    setupWindow()
    alertView = UIAlertPopupView(viewModel: viewModel)
    alertView?.confirmAction = {
      confirmAction()
    }
    alertView?.destructiveAction = {
      destructiveAction()
    }
    show()
  }
  
}

fileprivate extension AlertPopupManager {
  
  func setupWindow() {
    let rootVC = AlertRootViewController(statusBarStyle: .lightContent)
    window.alpha = 0
    window.backgroundColor = .clear
    window.rootViewController = rootVC
  }
  

  func show() {
    installSubviews()
    window.makeKeyAndVisible()
    UIView.animate(withDuration: 0.25, animations: {
      self.alertView?.alpha = 1
      self.window.alpha = 1
    }) { flag in
      
    }

  }
  
  func installSubviews() {
    window.rootViewController?.view.addSubview(mascotTipsView)
    window.rootViewController?.view.addSubview(alertView!)

    let mascotTop = hConvert812ToAll(154) + ScreenUtil.safeAreaInsets.top
    mascotTipsView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(mascotTop)
      make.leading.equalToSuperview().offset(wConvert375ToAll(56))
    }
    
    alertView?.setNeedsLayout()
    alertView?.layoutIfNeeded()
    alertView?.snp.makeConstraints { make in
      make.top.equalTo(mascotTipsView.snp.bottom).offset(-37)
      make.leading.equalToSuperview().offset(UIAlertPopupView.margin)
      make.trailing.equalToSuperview().offset(-UIAlertPopupView.margin)
    }
    
  }
  
}
