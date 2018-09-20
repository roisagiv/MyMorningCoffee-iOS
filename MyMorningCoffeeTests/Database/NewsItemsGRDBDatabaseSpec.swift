//
//  NewsItemRecordSpec.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 21/08/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

@testable import MyMorningCoffee
import Nimble
import Quick
import Result
import RxBlocking
import RxNimble
import RxSwift

class NewsItemsGRDBDatabaseSpec: QuickSpec {
  // swiftlint:disable:next function_body_length
  override func spec() {
    describe("Initial dataset") {
      it("does not override existing row") {
        let db = DatabaseFactory.create(log: true)
        do {
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)
          let id = 500
          // first save
          expect(database.save(item: NewsItemRecord(
            id: id
          )).error).to(beNil())
          expect(database.all()).first.to(haveCount(1))

          // second save
          expect(database.save(
            item: NewsItemRecord(
              id: id,
              time: Date(),
              title: "title title",
              url: nil,
              subTitle: "subTitle subTitle",
              imageUrl: nil,
              domain: nil,
              status: .fetched
            )
          ).error).to(beNil())

          // Test all
          let result = try database.all().toBlocking().first()
          expect(result).to(haveCount(1))
          expect(result?[0].title).to(equal("title title"))
          expect(result?[0].subTitle).to(equal("subTitle subTitle"))

          // Test by Id
          expect(database.record(by: id)).notTo(beNil())
        } catch {
          fail(error.localizedDescription)
        }
      }
    }

    describe("save items") {
      it("should save the entire array") {
        do {
          let db = DatabaseFactory.create()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }

          let result = database.save(items: records)
          expect(result.error).to(beNil())
        } catch {
          fail(error.localizedDescription)
        }
      }
    }

    describe("record by id") {
      it("returns record if exists") {
        do {
          let db = DatabaseFactory.create()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }
          _ = database.save(items: records)

          let result = try database.record(by: 5).toBlocking().first()!
          expect(result?.id).to(equal(5))
        } catch {
          fail(error.localizedDescription)
        }
      }

      it("returns record if exists rx") {
        do {
          let db = DatabaseFactory.create()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }
          _ = database.save(items: records)
          let record = try database.record(by: 0).toBlocking().first()!
          expect(record).toNot(beNil())
        } catch {
          fail(error.localizedDescription)
        }
      }
    }
  }
}
