//
//  DatabaseFactory.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 21/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
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
      configuration.trace = { print("SQL: \($0)") }
    }
    return try DatabasePool(path: databaseURL.path, configuration: configuration)
  }

  class func createInMemory(log: Bool = Environment.log) -> DatabaseWriter {
    var configuration = Configuration()
    if log {
      configuration.trace = { print("SQL: \($0)") }
    }
    return DatabaseQueue(configuration: configuration)
  }
}
