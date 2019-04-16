//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Firebase
import Foundation

protocol AnalyticsService {
  func track(event: AnalyticsEvent)
  func setEnabled(_ enabled: Bool)
}

struct FirebaseAnalyticsService: AnalyticsService {
  func setEnabled(_ enabled: Bool) {
    Analytics.setAnalyticsCollectionEnabled(enabled)
  }

  func track(event: AnalyticsEvent) {
    Analytics.logEvent(event.name, parameters: event.parameters)
  }
}
