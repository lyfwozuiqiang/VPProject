//
//  UICommonGradientButton.swift
//  SWUIKit
//
//  Created by Zacharyah on 2023/2/14.
//

import UIKit

public enum UICommonButtonStyle: Int {
  case gradientNormal
  case destructive
  case gradientPurple
}

public class UICommonButton: UIButton {

  public static var buttonHeight: Double = 48.0

  var btnWidth = 100.0
  var title: String = ""
  public let style: UICommonButtonStyle
  
  public static let titleFont: UIFont = .montserratSemiBoldFont(ofSize: 16)
    
  public init(style: UICommonButtonStyle) {
    self.style = style
    super.init(frame: CGRect.zero)
    self.frame = CGRect(x: 0, y: 0, width: btnWidth, height: UICommonButton.buttonHeight)
    backgroundColor = .clear
    clipsToBounds = true
    if style == .gradientNormal {
      installCommonGradientLayer()
    } else if style == .destructive {
//      backgroundColor = .alertBlack
      updateTitle("")
    } else if style == .gradientPurple {
      installPurpleGradientLayer()
    }
  }
  
  public convenience init(width: Double, title: String) {
    self.init(style: .gradientNormal)
    self.title = title
    self.btnWidth = width
    updateTitle(title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    let attrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UICommonButton.titleFont]
    let buttonMaxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: UICommonButton.buttonHeight)
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let size = title.boundingRect(with:buttonMaxSize, options: options, attributes: attrs, context: nil)
    return CGSize(width: size.width + 15 + 15, height: UICommonButton.buttonHeight)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
    if style == .gradientNormal || style == .gradientPurple {
      commonGradientLayer.frame = self.bounds
      commonGradientLayer.cornerRadius = layer.cornerRadius
    } else {
      commonGradientLayer.removeFromSuperlayer()
    }
  }
  
  public func updateTitle(_ title: String) {
    setTitle(title, for: .normal)
    setTitle(title, for: .selected)
    var color: UIColor?
    if style == .gradientNormal || style == .gradientPurple {
      color = .white
    } else if style == .destructive {
//      color = .alertCancel
//      backgroundColor = .alertBlack
    }
    setTitleColor(color, for: .normal)
    setTitleColor(color, for: .selected)
    titleLabel?.font = Self.titleFont
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  public func updateImage(_ image: UIImage?) {
    setImage(image, for: .normal)
    setImage(image, for: .selected)
    guard let imgView = imageView else { return }
    bringSubviewToFront(imgView)
  }

}
