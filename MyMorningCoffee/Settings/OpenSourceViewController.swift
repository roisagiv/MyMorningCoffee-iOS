//
//  OpenSourceViewController.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/11/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import AcknowList
import UIKit

class OpenSourceViewController: AcknowListViewController {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
}
