//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation

protocol AnalyticsEventType {
  var name: String { get }
  var parameters: [String: Any]? { get }
}

enum AnalyticsEvent: AnalyticsEventType {
  typealias RawValue = String

  case topNewsScreenView
  case newItemScreenView(url: String)

  var name: String {
    return "screen_\(self)"
  }

  var parameters: [String: Any]? {
    switch self {
    case let .newItemScreenView(url):
      return ["url": url]
    default:
      return nil
    }
  }
}
