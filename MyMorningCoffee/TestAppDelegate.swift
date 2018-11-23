//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
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

  static var window: UIWindow? {
    let appDelegate = UIApplication.shared.delegate as? TestAppDelegate
    return appDelegate?.window
  }
}
