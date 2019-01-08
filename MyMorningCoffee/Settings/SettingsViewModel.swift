//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Action
import RxCocoa
import RxDataSources
import RxSwift

struct SettingsViewModelSection {
  enum SettingsItem {
    case licenses
    case analytics(enabled: Bool)
    case version(number: String)
    case clearCache
    case appIcon

    var title: String {
      switch self {
      case .clearCache:
        return "Clear Cache"
      case .licenses:
        return "Acknowledgements"
      case .version:
        return "Version"
      case .analytics:
        return "Analyitcs"
      case .appIcon:
        return "Icon by Freepik from flaticon.com"
      }
    }

    var description: String? {
      switch self {
      case let .version(number):
        return number
      case .appIcon:
        return "Creative Commons BY 3.0"
      default:
        return nil
      }
    }

    var enabled: Bool? {
      switch self {
      case let .analytics(enabled):
        return enabled
      default:
        return nil
      }
    }

    var navigational: Bool {
      switch self {
      case .licenses, .appIcon:
        return true
      default:
        return false
      }
    }
  }

  enum SettingsItemSection: String {
    case about
    case general

    var title: String {
      return rawValue.capitalized
    }
  }

  let section: SettingsItemSection
  var items: [SettingsItem]
}

extension SettingsViewModelSection: SectionModelType {
  typealias Item = SettingsViewModelSection.SettingsItem

  init(original: SettingsViewModelSection, items: [SettingsViewModelSection.SettingsItem]) {
    self = original
    self.items = items
  }
}

protocol SettingsViewModelType {
  var items: Driver<[SettingsViewModelSection]> { get }
  var itemClicked: Action<SettingsViewModelSection.SettingsItem, Void> { get }
  var route: Driver<Router.Route> { get }
}

class SettingsViewModel: SettingsViewModelType {
  let route: Driver<Router.Route>

  private(set) lazy var items: Driver<[SettingsViewModelSection]> = {
    let versionNumber = "\(buildIdentity.version).\(buildIdentity.build)"
    return Driver.just([
      SettingsViewModelSection(section: .general, items: [
        SettingsViewModelSection.SettingsItem.analytics(enabled: true),
        SettingsViewModelSection.SettingsItem.clearCache
      ]),
      SettingsViewModelSection(section: .about, items: [
        SettingsViewModelSection.SettingsItem.licenses,
        SettingsViewModelSection.SettingsItem.appIcon,
        SettingsViewModelSection.SettingsItem.version(number: versionNumber)
      ])
    ])
  }()

  lazy var itemClicked: Action<SettingsViewModelSection.SettingsItem, Void> = {
    Action<SettingsViewModelSection.SettingsItem, Void> { [unowned self] settings in
      switch settings {
      case .licenses:
        self.routeSubject.onNext(Router.Route.licenses)
        break
      case .appIcon:
        self.routeSubject.onNext(Router.Route.iconAttribute)
        break
      default:
        break
      }
      return .empty()
    }
  }()

  private let buildIdentity: BuildIdentityServiceType
  private let routeSubject: PublishSubject<Router.Route>

  init(buildIdentity: BuildIdentityServiceType) {
    self.buildIdentity = buildIdentity
    routeSubject = PublishSubject<Router.Route>()
    route = routeSubject.asDriver(onErrorJustReturn: .topNews)
  }
}
