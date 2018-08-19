//
//  DatabaseMigrator.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 21/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB

class DatabaseMigrations {
  class func migrate(database: DatabaseWriter) throws {
    try migrator.migrate(database)
  }

  private static var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("v1.0") { database in
      try database.create(table: NewsItemRecord.databaseTableName) { table in
        table.column(NewsItemRecord.Columns.id.name, .integer).primaryKey()
        table.column(NewsItemRecord.Columns.domain.name, .text)
        table.column(NewsItemRecord.Columns.imageUrl.name, .text)
        table.column(NewsItemRecord.Columns.status.name, .text).notNull()
        table.column(NewsItemRecord.Columns.subTitle.name, .text)
        table.column(NewsItemRecord.Columns.time.name, .datetime).notNull()
        table.column(NewsItemRecord.Columns.title.name, .text)
        table.column(NewsItemRecord.Columns.url.name, .text)
      }
    }

    return migrator
  }
}
