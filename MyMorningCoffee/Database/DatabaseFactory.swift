//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import GRDB

class DatabaseFactory {
  class func create(log: Bool = Environment.log, clearDB: Bool = false) throws -> DatabaseWriter {
    let databaseURL = try FileManager.default
      .url(for: .applicationSupportDirectory,
           in: .userDomainMask,
           appropriateFor: nil,
           create: true)
      .appendingPathComponent("db.sqlite")

    if clearDB {
      try FileManager.default.removeItem(at: databaseURL)
    }

    var configuration = Configuration()
    if log {
      configuration.trace = { Logger.default.verbose("SQL: \($0)") }
    }
    return try DatabasePool(path: databaseURL.path, configuration: configuration)
  }

  class func createInMemory(log: Bool = Environment.log) -> DatabaseWriter {
    var configuration = Configuration()
    if log {
      configuration.trace = { Logger.default.verbose("SQL: \($0)") }
    }
    return DatabaseQueue(configuration: configuration)
  }
}
