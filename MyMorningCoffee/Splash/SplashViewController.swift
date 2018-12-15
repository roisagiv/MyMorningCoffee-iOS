//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import FirebaseAnalytics
import FirebaseCore
import FirebasePerformance
import GRDB
import MaterialComponents

class SplashViewController: UIViewController {
  private let appBar = MDCAppBarViewController()
  private var router: Router?
  private var remoteConfig: RemoteConfigType?
  private var databaseWriter: DatabaseWriter?
  private let activityIndicator = MDCActivityIndicator()

  override func viewDidLoad() {
    super.viewDidLoad()
    FirebaseConfiguration.shared.setLoggerLevel(.debug)
    Theme.apply(to: self)
    setupAppBar()

    activityIndicator.startAnimating()
    if let remoteConfig = remoteConfig {
      remoteConfig.fetch(completionHandler: { [unowned self, remoteConfig] status, error in
        if status == .success {
          _ = self.remoteConfig?.activateFetched()
        } else {
          print("error with config - \(error?.localizedDescription ?? "")")
        }
        do {
          if let databaseWriter = self.databaseWriter {
            try DatabaseMigrations.migrate(database: databaseWriter)
          }
        } catch {
          print("error with migration - \(error.localizedDescription)")
        }

        let appDelegate = UIApplication.shared.delegate as? AppDelegateType
        appDelegate?.remoteConfigDidFetch(remoteConfig: remoteConfig)
        self.router?.root(route: .topNews)
      })
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  private func setupAppBar() {
    Theme.apply(to: appBar)
    view.addSubview(appBar.view)
    addChild(appBar)
    appBar.didMove(toParent: self)
    appBar.navigationBar.title = ""

    Theme.apply(to: activityIndicator)
    activityIndicator.sizeToFit()
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicator)
    activityIndicator.centerXAnchor.constraint(
      equalTo: view.centerXAnchor
    ).isActive = true
    activityIndicator.centerYAnchor.constraint(
      equalTo: view.centerYAnchor
    ).isActive = true
  }
}

extension SplashViewController {
  class func create(router: Router,
                    remoteConfig: RemoteConfigType,
                    databaseWriter: DatabaseWriter) -> SplashViewController {
    let vc = SplashViewController()
    vc.router = router
    vc.remoteConfig = remoteConfig
    vc.databaseWriter = databaseWriter
    return vc
  }
}
