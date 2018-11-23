//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import AcknowList
import UIKit

class Router {
  enum Route {
    case topNews
    case item(url: URL, title: String)
    case settings

    func viewController() -> UIViewController {
      switch self {
      case .topNews:
        return TopNewsViewController.create(
          viewModel: Injector.topNewsViewModel,
          imageLoader: Injector.imageLoader,
          formatter: Injector.formatter,
          router: Injector.router
        )
      case let .item(url, title):
        return NewsItemViewController.create(url: url, title: title)

      case .settings:
        return OpenSourceViewController()
      }
    }
  }

  func root(route: Route,
            window: UIWindow?) {
    let vc = route.viewController()
    window?.rootViewController = UINavigationController(rootViewController: vc)
  }

  func navigate(to route: Route,
                from navigationController: UINavigationController?) {
    navigationController?.pushViewController(route.viewController(), animated: true)
  }
}
