//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Firebase
@testable import MyMorningCoffee

class StubRemoteConfig: RemoteConfigType {
  var analyticsEnabled: Bool {
    return false
  }

  var performanceMonitoringEnabled: Bool {
    return false
  }

  func activateFetched() -> Bool {
    return true
  }

  var completionHandler: RemoteConfigFetchCompletion?

  func fetch(completionHandler: RemoteConfigFetchCompletion? = nil) {
    self.completionHandler = completionHandler
  }

  func complete() {}
}
