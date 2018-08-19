//
//  AppDelegate.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Theme.configure()
    do {
      try Injector.configure()
    } catch {
      return false
    }
    let window = UIWindow(frame: UIScreen.main.bounds)
    let navigationController = UINavigationController(rootViewController: TopNewsViewController())
    window.rootViewController = navigationController

    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
