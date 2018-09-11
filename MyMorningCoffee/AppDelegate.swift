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
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Theme.configure()
    do {
      try Injector.configure()
      try DatabaseMigrations.migrate(database: Injector.databaseWriter)
    } catch {
      return false
    }
    let window = UIWindow(frame: UIScreen.main.bounds)
    let topNews = TopNewsViewController.create(
      viewModel: Injector.topNewsViewModel,
      imageLoader: Injector.imageLoader
    )
    let navigationController = UINavigationController(rootViewController: topNews)
    window.rootViewController = navigationController

    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
