//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

#if DEBUG
  import netfox
#endif
import RxSwift
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    #if DEBUG
//      NFX.sharedInstance().start()
    #endif
    Theme.configure()
    do {
      try Injector.configure()
      try DatabaseMigrations.migrate(database: Injector.databaseWriter)
    } catch {
      return false
    }
    let router = Injector.router
    let window = UIWindow(frame: UIScreen.main.bounds)
    router.root(route: .topNews, window: window)
    window.makeKeyAndVisible()

    self.window = window

    #if TRACE_RESOURCES
      _ = Observable<Int>
        .interval(1, scheduler: MainScheduler.instance)
        .subscribe(onNext: { _ in
          print("Resource count \(RxSwift.Resources.total)")
        })
    #endif
    return true
  }
}
