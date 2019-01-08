//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation
protocol BuildIdentityServiceType {
  var version: String { get }
  var build: String { get }
}

class BuildIdentityService: BuildIdentityServiceType {
  var version: String {
    guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
      return ""
    }
    return version
  }

  var build: String {
    guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
      return ""
    }
    return build
  }
}
