//
//  TestAppDelegate.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 19/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

class TestAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    Theme.configure()
    window = UIWindow(frame: UIScreen.main.bounds)

    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()

    return true
  }

  class func displayAsRoot(viewController: UIViewController) {
    let appDelegate = UIApplication.shared.delegate as? TestAppDelegate
    let window = appDelegate?.window
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
  }
}
