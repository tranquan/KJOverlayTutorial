//
//  KJOverlayTutorialVC.swift
//  Goody
//
//  Created by Kenji on 29/5/17.
//  Copyright © 2017 DevLander. All rights reserved.
//

import UIKit

class KJOverlayTutorialVC: UIViewController {
  
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
    // Dispose of any resources that can be recreated.
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
  
  func handleTapGesture(gesture: UITapGestureRecognizer) {
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
      lineLayer.path = createCurveLinePath(from: fromPoint, to: toPoint)
      lineLayer.strokeColor = UIColor.white.cgColor
      lineLayer.fillColor = nil
      lineLayer.lineWidth = 4.0;
      lineLayer.lineDashPattern = [10, 5, 5, 5]
      tutView.layer.addSublayer(lineLayer)
      
      // add arrow icon
      let arrowLayer = CAShapeLayer()
      arrowLayer.path = self.createArrowPathWithCurveLine(from: fromPoint, to: toPoint, size: 8.0)
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
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
      bgView.alpha = 1.0
    })
    UIView.animate(withDuration: 0.35, delay: 0.25, options: .curveEaseOut, animations: {
      tutView.alpha = 1.0
    })
  }
  
  func createCurveLinePath(from: CGPoint, to: CGPoint) -> CGPath {
    
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
  
  func createArrowPathWithCurveLine(from: CGPoint, to: CGPoint, size: CGFloat) -> CGPath {
    
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
