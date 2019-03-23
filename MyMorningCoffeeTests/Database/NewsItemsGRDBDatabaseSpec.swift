//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Fakery
@testable import MyMorningCoffee
import Nimble
import Quick
import Result
import RxBlocking
import RxSwift

class NewsItemsGRDBDatabaseSpec: QuickSpec {
  // swiftlint:disable force_try
  // swiftlint:disable function_body_length
  override func spec() {
    describe("Initial dataset") {
      it("does not override existing row") {
        let db = DatabaseFactory.createInMemory(log: true)
        do {
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)
          let id = 500
          // first save
          expect(database.insert(items: [NewsItemRecord(
            id: id
          )]).error).to(beNil())
          expect { try! database.all().toBlocking().first() }.to(haveCount(1))

          // second save
          expect(database.update(
            item: NewsItemRecord(
              id: id,
              time: Date(),
              timeRelative: "5 minutes ago",
              title: "title title",
              url: nil,
              subTitle: "subTitle subTitle",
              imageUrl: nil,
              logoUrl: nil,
              author: nil,
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
          let db = DatabaseFactory.createInMemory()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }

          let result = database.insert(items: records)
          expect(result.error).to(beNil())
        } catch {
          fail(error.localizedDescription)
        }
      }

      it("should keep existing items") {
        do {
          let db = DatabaseFactory.createInMemory()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          var records = Array(0 ..< length).map {
            NewsItemRecord(id: $0)
          }

          var result = database.insert(items: records)
          expect(result.error).to(beNil())

          records = self.fakeNewsItemRecords(count: length)
          result = database.insert(items: records)
          expect(result.error).to(beNil())
          expect { try database.all().toBlocking().first() }
            .to(satisfyAllOf(allPass { $0?.status == .empty }, haveCount(length)))
        } catch {
          fail(error.localizedDescription)
        }
      }
    }

    describe("record by id") {
      it("returns record if exists") {
        do {
          let db = DatabaseFactory.createInMemory()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }
          _ = database.insert(items: records)

          let result = try database.record(by: 5).toBlocking().first()!
          expect(result?.id).to(equal(5))
        } catch {
          fail(error.localizedDescription)
        }
      }

      it("returns record if exists rx") {
        do {
          let db = DatabaseFactory.createInMemory()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }
          _ = database.insert(items: records)
          let record = try database.record(by: 0).toBlocking().first()!
          expect(record).toNot(beNil())
        } catch {
          fail(error.localizedDescription)
        }
      }
    }

    describe("clear") {
      it("clears the items") {
        do {
          let db = DatabaseFactory.createInMemory()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }
          _ = database.insert(items: records)

          // act
          _ = database.clear()

          expect { try! database.all().toBlocking().first() }.to(haveCount(0))
        } catch {
          fail(error.localizedDescription)
        }
      }
    }

    describe("diskSize") {
      it("returns the file size on disk") {
        do {
          let db = DatabaseFactory.createInMemory()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          // act
          var results = database.diskSize()
          expect(results.value).to(equal(16384))

          // arrange
          let length = 500
          let records = Array(0 ... length).map {
            NewsItemRecord(id: $0)
          }
          _ = database.insert(items: records)

          // act
          results = database.diskSize()

          // assert
          expect(results.value).to(equal(40960))
        } catch {
          fail(error.localizedDescription)
        }
      }
    }

    describe("db trimming") {
      it("deletes older rows") {
        do {
          // arrange
          let db = DatabaseFactory.createInMemory()
          try DatabaseMigrations.migrate(database: db)
          let database = NewsItemsGRDBDatabase(databaseWriter: db)

          let length = 600
          let records = Array(0 ..< length).map {
            NewsItemRecord(id: $0)
          }
          _ = database.insert(items: records)

          expect { try! database.all().toBlocking().first() }.to(haveCount(600))
          expect { try database.record(by: 599).toBlocking().first()! }.toNot(beNil())
          expect { try database.record(by: 0).toBlocking().first()! }.toNot(beNil())

          // act
          try DatabaseMigrations.trim(database: db)

          // assert
          expect { try! database.all().toBlocking().first() }.to(haveCount(500))
          expect { try database.record(by: 599).toBlocking().first()! }.toNot(beNil())
          expect { try database.record(by: 0).toBlocking().first()! }.to(beNil())
        } catch {
          fail(error.localizedDescription)
        }
      }
    }
  }

  private func fakeNewsItemRecords(count: Int) -> [NewsItemRecord] {
    let faker = Faker()
    return Array(0 ..< count).map {
      NewsItemRecord(id: $0,
                     time: Date(),
                     timeRelative: nil,
                     title: faker.lorem.words(),
                     url: faker.internet.url(),
                     subTitle: nil,
                     imageUrl: nil,
                     logoUrl: nil,
                     author: nil,
                     domain: faker.internet.domainName(),
                     status: NewsItemRecord.Status.fetched)
    }
  }
}
