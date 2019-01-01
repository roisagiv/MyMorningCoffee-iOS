//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Moya

class MoyaProviderFactory {
  class func create<T: TargetType>(log: Bool = Environment.log) -> MoyaProvider<T> {
    var plugins: [PluginType] = []
    if log {
      plugins.append(NetworkLoggerPlugin(cURL: false))
    }
    return MoyaProvider<T>(plugins: plugins)
  }
}
