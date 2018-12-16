//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import UIKit

enum Device {
  case iPhoneSE
  case iPhone8
  case iPhone8Plus
  case iPhoneX

  var size: CGSize {
    switch self {
    case .iPhoneSE: return CGSize(width: 320, height: 568)
    case .iPhone8: return CGSize(width: 375, height: 667)
    case .iPhone8Plus: return CGSize(width: 414, height: 736)
    case .iPhoneX: return CGSize(width: 375, height: 812)
    }
  }

  var name: String {
    switch self {
    case .iPhoneSE: return "iPhoneSE"
    case .iPhone8: return "iPhone8"
    case .iPhone8Plus: return "iPhone8Plus"
    case .iPhoneX: return "iPhoneX"
    }
  }

  static let sizes: [String: CGSize] = [
    Device.iPhoneSE.name: Device.iPhoneSE.size,
    Device.iPhone8.name: Device.iPhone8.size,
    Device.iPhone8Plus.name: Device.iPhone8Plus.size,
    Device.iPhoneX.name: Device.iPhoneX.size
  ]

  static func showController(_ viewController: UIViewController, window: UIWindow = UIWindow()) {
    let frame: CGRect
    let view: UIView = viewController.view
    if view.frame.size.width > 0, view.frame.size.height > 0 {
      frame = CGRect(origin: .zero, size: view.frame.size)
    } else {
      frame = UIScreen.main.bounds
    }

    viewController.loadViewIfNeeded()

    window.rootViewController = viewController
    window.frame = frame
    window.makeKeyAndVisible()
    viewController.view.layoutIfNeeded()
  }

  static func showView(_ view: UIView, container: UIView = UIView()) {
    let controller = UIViewController()
    controller.view.frame.size = view.frame.size
    container.frame.size = view.frame.size
    view.frame.origin = .zero
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.translatesAutoresizingMaskIntoConstraints = true
    container.addSubview(view)
    controller.view.addSubview(container)

    showController(controller)
  }
}
