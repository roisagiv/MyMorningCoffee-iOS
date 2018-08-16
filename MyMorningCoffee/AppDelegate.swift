//
//  AppDelegate.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 16/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let navigationController = UINavigationController(rootViewController: TopNewsViewController())
    window.rootViewController = navigationController

    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
