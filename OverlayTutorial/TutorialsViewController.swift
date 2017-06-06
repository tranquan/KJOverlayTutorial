//
//  TutorialExample.swift
//  OverlayTutorial
//
//  Created by Kenji on 6/6/17.
//  Copyright © 2017 DevLander. All rights reserved.
//

import UIKit

class TutorialsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

// MARK: - UITableView DataSource

extension TutorialsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCell", for: indexPath)
    
    if let titleLabel = cell.viewWithTag(1) as? UILabel {
      switch indexPath.row {
      case 0:
        titleLabel.text = "Text + Arrow Tutorial"
      case 1:
        titleLabel.text = "Text + Icon Tutorial"
      case 2:
        titleLabel.text = "Multiple Tutorial"
      default:
        break
      }
    }
    
    return cell
  }
  
}

// MARK: - UITableView Delegate

extension TutorialsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.row {
    case 0:
      self.performSegue(withIdentifier: "showTut1", sender: nil)
    case 1:
      self.performSegue(withIdentifier: "showTut2", sender: nil)
    case 2:
      self.performSegue(withIdentifier: "showTut3", sender: nil)
    default:
      break
    }
  }
}
