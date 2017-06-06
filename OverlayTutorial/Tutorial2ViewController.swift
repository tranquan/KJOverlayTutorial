//
//  Tutorial2ViewController.swift
//  OverlayTutorial
//
//  Created by Kenji on 6/6/17.
//  Copyright © 2017 DevLander. All rights reserved.
//

import UIKit

class Tutorial2ViewController: UIViewController {
  
  @IBOutlet weak var imvTut: UIImageView!
  
  lazy var tutorialVC: KJOverlayTutorialVC = {
    return KJOverlayTutorialVC()
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.showTutorial()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func showTutorial() {
    
    // tut1
    let focusRect1 = self.imvTut.frame
    let icon1Frame = CGRect(x: self.view.bounds.width/2-72/2, y: focusRect1.maxY + 12, width: 72, height: 72)
    let message1 = "This is your QRCode. Please show this to the waiter to get discount"
    let message1Center = CGPoint(x: self.view.bounds.width/2, y: icon1Frame.maxY + 24)
    var tut1 = KJTutorial.textTutorial(focusRectangle: focusRect1, text: message1, textPosition: message1Center)
    tut1.isArrowHidden = false
    
    // tuts
    let tutorials = [tut1]
    self.tutorialVC.tutorials = tutorials
    self.tutorialVC.showInViewController(self)
  }

}
