//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import GRDB

class DatabaseMigrations {
  class func migrate(database: DatabaseWriter) throws {
    #if DEBUG
//      try database.erase()
    #endif
    try migrator.migrate(database)
  }

  class func trim(database: DatabaseWriter) throws {
    try database.write { db in
      try db.execute("""
      DELETE FROM \(NewsItemRecord.databaseTableName)
      WHERE \(NewsItemRecord.Columns.id.name) < (
          SELECT MIN(\(NewsItemRecord.Columns.id.name))
          FROM (SELECT \(NewsItemRecord.Columns.id.name)
                FROM \(NewsItemRecord.databaseTableName)
                ORDER BY \(NewsItemRecord.Columns.id.name) DESC
                LIMIT 500))
      """)
    }
  }

  private static var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()
    #if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
    #endif

    migrator.registerMigration("v1.0") { database in
      try database.create(table: NewsItemRecord.databaseTableName) { table in
        table.column(NewsItemRecord.Columns.id.name, .integer).primaryKey()
        table.column(NewsItemRecord.Columns.domain.name, .text)
        table.column(NewsItemRecord.Columns.imageUrl.name, .text)
        table.column(NewsItemRecord.Columns.status.name, .text).notNull()
        table.column(NewsItemRecord.Columns.subTitle.name, .text)
        table.column(NewsItemRecord.Columns.time.name, .datetime).notNull()
        table.column(NewsItemRecord.Columns.timeRelative.name, .text)
        table.column(NewsItemRecord.Columns.title.name, .text)
        table.column(NewsItemRecord.Columns.url.name, .text)
      }
    }

    return migrator
  }
}
