//
//  KJTutorial.swift
//  Goody
//
//  Created by Kenji on 29/5/17.
//  Copyright © 2017 DevLander. All rights reserved.
//

import UIKit

struct KJTutorial {
  
  enum KJTutorialPosition {
    case top
    case bottom
  }
  
  // MARK: - Configs
  
  static var leftPadding: CGFloat = 20
  static var rightPadding: CGFloat = 20
  static var topPadding: CGFloat = 64
  static var bottomPadding: CGFloat = 64
  
  // MARK: - Props
  
  var focusRectangle: CGRect
  var focusRectangleCornerRadius: CGFloat
  var message: NSAttributedString
  var messagePosition: CGPoint
  var icon: UIImage? = nil
  var iconFrame: CGRect = CGRect.zero
  var isArrowHidden: Bool = false
  
  // MARK: - Helpers
  
  static func getMessageFrameAt(position: KJTutorialPosition, message: String, font: UIFont) -> CGRect {
    
    let screenBounds = UIScreen.main.bounds
    
    let size = font.sizeOf(string: message, constrainedToWidth: screenBounds.size.width - leftPadding - rightPadding)
    
    let x = CGFloat(max(leftPadding, (screenBounds.size.width-size.width)/2.0))
    
    var y = screenBounds.size.width/2.0
    switch position {
    case .top:
      y = topPadding
    case .bottom:
      y = screenBounds.size.height - size.height - bottomPadding
    }
    
    return CGRect(x: x, y: y, width: size.width, height: size.height)
  }
  
  static func textTutorial(focusRectangle: CGRect, text: String, textPosition: CGPoint) -> KJTutorial {
    let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                 NSForegroundColorAttributeName : UIColor.white]
    let message = NSAttributedString(string: text, attributes: attrs)
    let tutorial = KJTutorial(focusRectangle: focusRectangle, focusRectangleCornerRadius: 4.0, message: message, messagePosition: textPosition, icon: nil, iconFrame: .zero, isArrowHidden: false)
    return tutorial
  }
  
  static func textWithIconTutorial(focusRectangle: CGRect, text: String, textPosition: CGPoint, icon: UIImage, iconFrame: CGRect) -> KJTutorial {
    let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                 NSForegroundColorAttributeName : UIColor.white]
    let message = NSAttributedString(string: text, attributes: attrs)
    let tutorial = KJTutorial(focusRectangle: focusRectangle, focusRectangleCornerRadius: 4.0, message: message, messagePosition: textPosition, icon: icon, iconFrame: iconFrame, isArrowHidden: true)
    return tutorial
  }
  
}
