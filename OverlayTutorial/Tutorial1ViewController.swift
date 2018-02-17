//
//  Tutorial1ViewController.swift
//  OverlayTutorial
//
//  Created by Kenji on 6/6/17.
//  Copyright © 2017 DevLander. All rights reserved.
//

import UIKit
import SwiftIconFont


class Tutorial1ViewController: UIViewController {
  
  @IBOutlet weak var tvTut: UITextView!
  
  lazy var tutorialVC: KJOverlayTutorialViewController = {
    return KJOverlayTutorialViewController()
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.showTutorial()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func showTutorial() {
    
    // tut1
    let focusRect1 = self.tvTut.frame
    let icon1 = UIImage(from: .FontAwesome, code: "handoup", textColor: .white, backgroundColor: .clear, size: CGSize(width: 72, height: 72))
    let icon1Frame = CGRect(x: self.view.bounds.width/2-72/2, y: focusRect1.maxY + 12, width: 72, height: 72)
    let message1 = "Hello, this is tutorial 1"
    let message1Center = CGPoint(x: self.view.bounds.width/2, y: icon1Frame.maxY + 24)
    let tut1 = KJTutorial.textWithIconTutorial(focusRectangle: focusRect1, text: message1, textPosition: message1Center, icon: icon1, iconFrame: icon1Frame)
    
    // tuts
    let tutorials = [tut1]
    self.tutorialVC.tutorials = tutorials
    self.tutorialVC.showInViewController(self)
  }
}
