//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Firebase

protocol RemoteConfigType {
  func fetch(completionHandler: RemoteConfigFetchCompletion?)

  var analyticsEnabled: Bool { get }

  var performanceMonitoringEnabled: Bool { get }
}

class FirebaseRemoteConfig: RemoteConfigType {
  private let remoteConfig: RemoteConfig
  private let developmentMode: Bool

  init(remoteConfig: RemoteConfig, developmentMode: Bool = false) {
    self.remoteConfig = remoteConfig
    self.developmentMode = developmentMode
  }

  func fetch(completionHandler: RemoteConfigFetchCompletion?) {
    if developmentMode {
      remoteConfig.configSettings.minimumFetchInterval = 0
    }
    remoteConfig.fetch { [completionHandler, unowned self] status, error in
      if let error = error {
        completionHandler?(status, error)
      }
      self.remoteConfig.activate { error in
        if let error = error {
          completionHandler?(.failure, error)
        } else {
          completionHandler?(status, error)
        }
      }
    }
  }

  var analyticsEnabled: Bool {
    return remoteConfig.configValue(forKey: "analytics_enabled").boolValue
  }

  var performanceMonitoringEnabled: Bool {
    return remoteConfig.configValue(forKey: "performance_monitoring_enabled").boolValue
  }
}
