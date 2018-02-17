/**
 * Copyright © SaigonMD, Inc - All Rights Reserved
 * Licensed under the MIT license.
 * Written by Tran Quan <tranquan221b@gmail.com>, Feb 2018
 */


import UIKit
import pop


class KJOverlayTutorialViewController: UIViewController {
  
  var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.8)
  
  var tutorials: [KJTutorial] = []
  var currentTutorialIndex = 0
  
  lazy var hintLabel: UILabel = {
    let label = UILabel()
    label.text = "(Tap to continue)"
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
    self.view.addGestureRecognizer(tap)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Methods
  
  func showInViewController(_ viewController: UIViewController) {
    
    let window = viewController.view.window!
    
    self.view.frame = window.bounds
    window.addSubview(self.view)
    
    viewController.addChildViewController(self)
    self.didMove(toParentViewController: viewController)
    
    self.currentTutorialIndex = -1
    self.showNextTutorial()
  }
  
  func close() {
    self.willMove(toParentViewController: nil)
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
  
  @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
    self.showNextTutorial()
  }
  
  func showNextTutorial() {
    currentTutorialIndex += 1
    
    if currentTutorialIndex >= self.tutorials.count {
      self.close()
      return
    }
    
    let tut = self.tutorials[self.currentTutorialIndex]
    self.showTutorial(tut)
  }
  
  func showTutorial(_ tutorial: KJTutorial) {
    
    // remove old tutorial
    self.view.backgroundColor = UIColor.clear
    for subView in self.view.subviews {
      if subView.tag == 9999 {
        subView.removeFromSuperview()
      }
    }
    
    // config tutorial
    let bgView = UIView(frame: self.view.bounds)
    bgView.tag = 9999
    bgView.backgroundColor = self.overlayColor
    
    // add focus region
    let path = CGMutablePath()
    path.addRect(self.view.bounds)
    path.addRoundedRect(in: tutorial.focusRectangle,
                        cornerWidth: tutorial.focusRectangleCornerRadius,
                        cornerHeight: tutorial.focusRectangleCornerRadius)
    let maskLayer = CAShapeLayer()
    maskLayer.path = path
    maskLayer.fillRule = kCAFillRuleEvenOdd
    bgView.clipsToBounds = true
    bgView.layer.mask = maskLayer
    
    let tutView = UIView(frame: self.view.bounds)
    tutView.tag = 9999
    tutView.backgroundColor = UIColor.clear
    
    // add message
    let lblMessage = UILabel()
    lblMessage.numberOfLines = 0
    lblMessage.textAlignment = .center
    lblMessage.attributedText = tutorial.message
    let fitSize = lblMessage.sizeThatFits(CGSize(width: bgView.bounds.size.width-40,
                                                 height: bgView.bounds.size.height))
    lblMessage.frame.size = fitSize
    lblMessage.center = tutorial.messagePosition
    tutView.addSubview(lblMessage)
    
    // add image
    if let icon = tutorial.icon {
      let imvIcon = UIImageView(frame: tutorial.iconFrame)
      imvIcon.image = icon
      imvIcon.contentMode = .scaleAspectFit
      tutView.addSubview(imvIcon)
    }
    
    if !tutorial.isArrowHidden {
      
      // add arrow line
      let fromPoint = lblMessage.frame.topCenterPoint.moveY(-4)
      let toPoint = tutorial.focusRectangle.bottomCenterPoint.moveY(16)
      
      let lineLayer = CAShapeLayer()
      lineLayer.path = KJOverlayTutorialViewController.createCurveLinePath(from: fromPoint, to: toPoint)
      lineLayer.strokeColor = UIColor.white.cgColor
      lineLayer.fillColor = nil
      lineLayer.lineWidth = 4.0;
      lineLayer.lineDashPattern = [10, 5, 5, 5]
      tutView.layer.addSublayer(lineLayer)
      
      // add arrow icon
      let arrowLayer = CAShapeLayer()
      arrowLayer.path = KJOverlayTutorialViewController.createArrowPathWithCurveLine(from: fromPoint, to: toPoint, size: 8.0)
      arrowLayer.strokeColor = UIColor.white.cgColor
      arrowLayer.fillColor = UIColor.white.cgColor
      arrowLayer.lineWidth = 1.0;
      tutView.layer.addSublayer(arrowLayer)
    }
    
    // showing
    bgView.alpha = 0.0
    tutView.alpha = 0.0
    self.view.addSubview(bgView)
    self.view.addSubview(tutView)
    
    // fade animation
//    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
//      bgView.alpha = 1.0
//    })
//    UIView.animate(withDuration: 0.35, delay: 0.25, options: .curveEaseOut, animations: {
//      tutView.alpha = 1.0
//    })
    
    // focus animation
    bgView.alpha = 1.0
    let focusAnim = KJOverlayTutorialViewController.createFocusAnimation(outsideRect: self.view.bounds, focusRect: tutorial.focusRectangle, cornerRadius: 4.0, duration: 0.35)
    maskLayer.add(focusAnim, forKey: nil)
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    maskLayer.path = path
    CATransaction.commit()
    
    // floating animation
    tutView.alpha = 1.0
    let floatingAnim = KJOverlayTutorialViewController.createFloatingPOPAnimation(centerPoint: tutView.center, float: 8)
    tutView.pop_add(floatingAnim, forKey: nil)
  }
}

// MARK: - Path Helper

extension KJOverlayTutorialViewController {
  
  static func createCurveLinePath(from: CGPoint, to: CGPoint) -> CGPath {
    
    let vector = CGPoint.createVector(from: from, to: to, isUnit: true)
    let perpendVector = CGPoint.createPerpendicularVectorWith(vector: vector)
    let distance = CGFloat(CGPoint.distanceOf(p1: from, p2: to) * 0.085)
    
    let centerPoint = CGPoint(x: (from.x + to.x)/2.0, y: (from.y + to.y)/2.0)
    let controlDirection: CGFloat = from.x <= to.x ? -1 : 1
    let controlPoint = CGPoint(x: centerPoint.x + perpendVector.x * distance,
                               y: centerPoint.y + perpendVector.y * distance * controlDirection)
    
    let path = CGMutablePath()
    path.move(to: from)
    path.addQuadCurve(to: to, control: controlPoint)
    return path
  }
  
  static func createArrowPathWithCurveLine(from: CGPoint, to: CGPoint, size: CGFloat) -> CGPath {
    
    // vectors
    let vector = CGPoint.createVector(from: from, to: to, isUnit: true)
    
    let controlDirection: CGFloat = from.x <= to.x ? -1 : 1
    let distance = CGFloat(CGPoint.distanceOf(p1: from, p2: to) * 0.00085) * controlDirection
    var fromCurve = CGPoint(x: to.x - vector.x, y: to.y - vector.y)
    fromCurve = CGPoint(x: fromCurve.x + (-vector.y) * distance, y: fromCurve.y + vector.x * distance)
    
    let curveVector = CGPoint.createVector(from: fromCurve, to: to, isUnit: false)
    let reverseVector = CGPoint.createReverseVectorWith(vector: curveVector)
    let perpendVector = CGPoint.createPerpendicularVectorWith(vector: curveVector)
    
    // calculate points
    let centerPoint = CGPoint(x: to.x + reverseVector.x * size,
                              y: to.y + reverseVector.y * size)
    let leftPoint = CGPoint(x: centerPoint.x - perpendVector.x * size * 0.5,
                            y: centerPoint.y - perpendVector.y * size * 0.5)
    let rightPoint = CGPoint(x: centerPoint.x + perpendVector.x * size * 0.5,
                             y: centerPoint.y + perpendVector.y * size * 0.5)
    
    // make triangle
    let path = CGMutablePath()
    path.move(to: to)
    path.addLine(to: leftPoint)
    path.addLine(to: rightPoint)
    path.closeSubpath()
    return path
  }
  
}

// MARK: - Animation Helper

extension KJOverlayTutorialViewController {
  
  static func createFloatingPOPAnimation(centerPoint: CGPoint, float: CGFloat) -> POPAnimation {
    
    let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)!
    
    anim.fromValue = NSValue(cgPoint: centerPoint)
    anim.toValue = NSValue(cgPoint: centerPoint.moveY(-8))
    anim.springBounciness = 0
    anim.springSpeed = 1
    anim.autoreverses = true
    anim.repeatForever = true
    
    return anim;
  }
  
  static func createFocusAnimation(outsideRect: CGRect, focusRect: CGRect, cornerRadius: CGFloat, duration: CFTimeInterval) -> CAAnimation {
    
    let duration1 = duration * 0.4
    let duration2 = duration * 0.3
    let duration3 = duration - duration1 - duration2
    let begin1 = 0.0
    let begin2 = begin1 + duration1
    let begin3 = begin2 + duration2
    
    let distance = min(12, min(focusRect.width, focusRect.height) - 8);
    let offset1 = distance
    let offset2 = distance * 0.5
    
    let rect0 = outsideRect
    let rect1 = focusRect.insetBy(dx: offset1, dy: offset1)
    let rect2 = focusRect.insetBy(dx: -offset2, dy: -offset2)
    let rect3 = focusRect
    
    let path0 = CGMutablePath()
    path0.addRect(rect0)
    path0.addRoundedRect(in: rect0, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
    
    let path1 = CGMutablePath()
    path1.addRect(rect0)
    path1.addRoundedRect(in: rect1, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
    
    let path2 = CGMutablePath()
    path2.addRect(rect0)
    path2.addRoundedRect(in: rect2, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
    
    let path3 = CGMutablePath()
    path3.addRect(rect0)
    path3.addRoundedRect(in: rect3, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
    
    let anim1 = createPathAnimation(fromPath: path0, toPath: path1, beginTime: begin1, duration: duration1)
    let anim2 = createPathAnimation(fromPath: path1, toPath: path2, beginTime: begin2, duration: duration2)
    let anim3 = createPathAnimation(fromPath: path2, toPath: path3, beginTime: begin3, duration: duration3)
    
    let anim = CAAnimationGroup()
    anim.duration = duration
    anim.animations = [anim1, anim2, anim3]
    return anim
  }
  
  static func createPathAnimation(fromPath: CGPath, toPath: CGPath, beginTime: CFTimeInterval, duration: CFTimeInterval) -> CABasicAnimation {
    
    let anim = CABasicAnimation(keyPath: "path")
    
    anim.fromValue = fromPath
    anim.toValue = toPath
    anim.beginTime = beginTime
    anim.duration = duration
    
    return anim
  }
  
}
