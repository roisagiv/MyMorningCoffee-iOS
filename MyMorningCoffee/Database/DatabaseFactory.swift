//
//  DatabaseFactory.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 21/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB

class DatabaseFactory {
  class func create(log: Bool = Environment.log) -> DatabaseWriter {
    var configuration = Configuration()
    if log {
      configuration.trace = { print("SQL: \($0)") }
    }
    return DatabaseQueue(configuration: configuration)
  }

  class func createInMemory(log: Bool = Environment.log) -> DatabaseWriter {
    var configuration = Configuration()
    if log {
      configuration.trace = { print("SQL: \($0)") }
    }
    return DatabaseQueue(configuration: configuration)
  }
}
