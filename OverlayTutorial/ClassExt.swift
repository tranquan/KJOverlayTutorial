/**
 * Copyright © SaigonMD, Inc - All Rights Reserved
 * Licensed under the MIT license.
 * Written by Tran Quan <tranquan221b@gmail.com>, Feb 2018
 */

import UIKit

extension CGRect {
  
  var centerPoint: CGPoint {
    return CGPoint(x: self.origin.x + self.size.width/2, y: self.origin.y + self.size.height/2)
  }
  
  var topCenterPoint: CGPoint {
    return CGPoint(x: self.origin.x + self.size.width/2, y: self.origin.y)
  }
  
  var bottomCenterPoint: CGPoint {
    return CGPoint(x: self.origin.x + self.size.width/2, y: self.origin.y + self.size.height)
  }
  
  var leftCenterPoint: CGPoint {
    return CGPoint(x: self.origin.x, y: self.origin.y + self.size.height/2)
  }
  
  var rightCenterPoint: CGPoint {
    return CGPoint(x: self.origin.x + self.size.width, y: self.origin.y + self.size.height/2)
  }
  
}

extension CGPoint {
  
  func moveX(_ d: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + d, y: self.y)
  }
  
  func moveY(_ d: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y + d)
  }
  
  static func distanceOf(p1: CGPoint, p2: CGPoint) -> Double {
    let length = sqrt(Double((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y)))
    return length
  }
  
  static func createVector(from: CGPoint, to: CGPoint, isUnit: Bool = false) -> CGPoint {
    let vector = CGPoint(x: to.x - from.x, y: to.y - from.y)
    return isUnit ? CGPoint.createUnitVectorWith(vector: vector) : vector
  }
  
  static func createUnitVectorWith(vector: CGPoint) -> CGPoint {
    var division = max(fabs(vector.x), fabs(vector.y))
    if division == 0 { division = 1 }
    division = CGFloat(fabs(division))
    return CGPoint(x: vector.x/division, y: vector.y/division)
  }
  
  static func createReverseVectorWith(vector: CGPoint) -> CGPoint {
    return CGPoint(x: -vector.x, y: -vector.y)
  }
  
  static func createPerpendicularVectorWith(vector: CGPoint) -> CGPoint {
    return CGPoint(x: -vector.y, y: vector.x)
  }
}

extension UIFont {
  
  func sizeOf(string: String, constrainedToWidth width: CGFloat) -> CGSize {
    return NSString(string: string).boundingRect(with: CGSize(width: width, height: 9999_9999), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : self], context: nil).size
  }
  
}
