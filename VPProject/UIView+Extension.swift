//
//  UIView+Extension.swift
//  MSUIKit
//
//  Created by Zacharyah on 2022/10/21.
//

import UIKit
import UIColor_Hex_Swift

// MARK: CommonGradientLayer
fileprivate var AssociatedCommonGradientLayer: String = "AssociatedCommonGradientLayer"

public extension UIView {
  
  var commonGradientLayer: CAGradientLayer {
    get {
      guard let layer = objc_getAssociatedObject(self, &AssociatedCommonGradientLayer) as? CAGradientLayer else {
        let gradientLayer = CAGradientLayer()
        objc_setAssociatedObject(self, &AssociatedCommonGradientLayer, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gradientLayer
      }
      return layer
    }
  }
  
  func installCommonGradientLayer() {
    setNeedsLayout()
    layoutIfNeeded()
    commonGradientLayer.colors = [
      // purple
      UIColor(red: 0.961, green: 0.306, blue: 0.976, alpha: 1).cgColor,
      UIColor(red: 0.4, green: 0.192, blue: 1, alpha: 1).cgColor,
      UIColor(red: 0.433, green: 0.816, blue: 1, alpha: 1).cgColor,
    ]
    commonGradientLayer.locations = [0, 0.47, 1]
    commonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    commonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    commonGradientLayer.frame = self.bounds
    commonGradientLayer.cornerRadius = layer.cornerRadius
    layer.insertSublayer(commonGradientLayer, at: 0)
  }

  func installPurpleGradientLayer() {
    setNeedsLayout()
    layoutIfNeeded()
    commonGradientLayer.colors = [
      UIColor(hex6: 0xF54EF9, alpha: 1).cgColor,
      UIColor(hex6: 0x632DFF, alpha: 1).cgColor,
    ]
    commonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    commonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    commonGradientLayer.frame = self.bounds
    commonGradientLayer.cornerRadius = layer.cornerRadius
    layer.insertSublayer(commonGradientLayer, at: 0)
  }

  
  func addShadow() {
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 4
    layer.shadowOpacity = 0.3
    layer.masksToBounds = false
  }
    
}
