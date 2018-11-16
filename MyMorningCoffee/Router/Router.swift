//
//  Router.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 10/11/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
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