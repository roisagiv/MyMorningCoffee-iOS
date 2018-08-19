//
//  MoyaProviderFactory.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 21/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Moya

class MoyaProviderFactory {
  class func create<T: TargetType>(log: Bool = Environment.log) -> MoyaProvider<T> {
    var plugins: [PluginType] = []
    if log {
      plugins.append(NetworkLoggerPlugin(cURL: true))
    }
    return MoyaProvider<T>(plugins: plugins)
  }
}
