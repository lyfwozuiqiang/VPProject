//
//  UIFont.swift
//  SWUIKit
//
//  Created by Zacharyah on 2022/12/8.
//

import Foundation
import UIKit

public extension UIFont {
  
  static func font(ofName: String, ofSize: CGFloat) -> UIFont {
    UIFont(name: ofName, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
  }
  
  static func pingFangSCRFont(ofSize fontSize: CGFloat) -> UIFont {
    font(ofName: "PingFangSC-Regular", ofSize: fontSize)
  }
  
  static func russoOneFont(ofSize fontSize: CGFloat) -> UIFont {
    font(ofName: "RussoOne-Regular", ofSize: fontSize)
  }
  
  static func montserratRegularFont(ofSize fontSize: CGFloat) -> UIFont {
    font(ofName: "Montserrat-Regular", ofSize: fontSize)
  }
  
  static func montserratMediumFont(ofSize fontSize: CGFloat) -> UIFont {
    font(ofName: "Montserrat-Medium", ofSize: fontSize)
  }
  
  static func montserratSemiBoldFont(ofSize fontSize: CGFloat) -> UIFont {
    font(ofName: "Montserrat-SemiBold", ofSize: fontSize)
  }
  
  static func montserratSemiBoldItalicFont(ofSize fontSize: CGFloat) -> UIFont {
    font(ofName: "Montserrat-SemiBoldItalic", ofSize: fontSize)
  }

}
