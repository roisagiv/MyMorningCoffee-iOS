//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import MaterialComponents
import SafariServices
import UIKit

class Router {
  enum Route {
    case splash
    case topNews
    case item(url: URL, title: String)
    case settings
    case licenses
    case iconAttribute

    func viewController() -> UIViewController {
      switch self {
      case .topNews:
        return TopNewsViewController.create(
          viewModel: Injector.topNewsViewModel,
          imageLoader: Injector.imageLoader,
          router: Injector.router
        )
      case let .item(url, title):
        let analyticsService = Injector.analyticsService
        return NewsItemViewController.create(url: url, title: title, analyticsService: analyticsService)

      case .settings:
        return SettingsViewController.create(
          viewModel: Injector.settingsViewModel,
          router: Injector.router
        )

      case .licenses:
        return OpenSourceViewController()

      case .iconAttribute:
        return SFSafariViewController(url: URL(string: "https://www.flaticon.com")!)

      case .splash:
        return SplashViewController.create(
          router: Injector.router,
          remoteConfig: Injector.remoteConfig,
          databaseWriter: Injector.databaseWriter
        )
      }
    }
  }

  func root(route: Route) {
    let vc = route.viewController()
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    let window = appDelegate?.window
    let nc = MDCAppBarNavigationController(rootViewController: vc)
    nc.delegate = appDelegate
    window?.rootViewController = nc
  }

  func navigate(to route: Route,
                from navigationController: UINavigationController?) {
    let vc = route.viewController()
    switch route {
    case .iconAttribute:
      navigationController?.present(vc, animated: true, completion: nil)
    default:
      navigationController?.pushViewController(route.viewController(), animated: true)
    }
  }
}
