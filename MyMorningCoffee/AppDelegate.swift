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
import FirebasePerformance
import RxSwift
import UIKit

protocol AppDelegateType {
  func remoteConfigDidFetch(remoteConfig: RemoteConfigType)
}

class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateType {
  var window: UIWindow?

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Start with off, may be turn on later, could not find configa
    Performance.sharedInstance().isDataCollectionEnabled = false
    Performance.sharedInstance().isInstrumentationEnabled = false

    #if DEBUG
      NFX.sharedInstance().start()
    #endif

    Theme.configure()
    Injector.initialize()

    let router = Injector.router
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window

    router.root(route: .splash)

    window.makeKeyAndVisible()

    #if TRACE_RESOURCES
      _ = Observable<Int>
        .interval(1, scheduler: MainScheduler.instance)
        .subscribe(onNext: { _ in
          print("Resource count \(RxSwift.Resources.total)")
        })
    #endif

    return true
  }

  func remoteConfigDidFetch(remoteConfig: RemoteConfigType) {
    let performanceEnabled = remoteConfig.analyticsEnabled
    // Start with off, may be turn on later, could not find configa
    Performance.sharedInstance().isDataCollectionEnabled = performanceEnabled
    Performance.sharedInstance().isInstrumentationEnabled = performanceEnabled

    Injector.configure(remoteConfig: remoteConfig)
  }
}
