//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Firebase

protocol RemoteConfigType {
  func fetch(completionHandler: RemoteConfigFetchCompletion?)

  func activateFetched() -> Bool

  var analyticsEnabled: Bool { get }

  var performanceMonitoringEnabled: Bool { get }
}

class FirebaseRemoteConfig: RemoteConfigType {
  private let remoteConfig: RemoteConfig

  init(remoteConfig: RemoteConfig) {
    self.remoteConfig = remoteConfig
  }

  func fetch(completionHandler: RemoteConfigFetchCompletion?) {
    var expirationDuration: Double = 3600
    if remoteConfig.configSettings.isDeveloperModeEnabled {
      expirationDuration = 0
    }
    remoteConfig.fetch(
      withExpirationDuration: expirationDuration,
      completionHandler: completionHandler
    )
  }

  func activateFetched() -> Bool {
    return remoteConfig.activateFetched()
  }

  var analyticsEnabled: Bool {
    return remoteConfig.configValue(forKey: "analytics_enabled").boolValue
  }

  var performanceMonitoringEnabled: Bool {
    return remoteConfig.configValue(forKey: "performance_monitoring_enabled").boolValue
  }
}
