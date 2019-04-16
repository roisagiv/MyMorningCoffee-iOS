//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

@testable import MyMorningCoffee
import Result
import RxSwift

class StubNewsItemDatabase: NewsItemsDatabaseType {
  func update(item: NewsItemRecord) -> Result<Void, AnyError> {
    return underline.update(item: item)
  }

  func insert(items: [NewsItemRecord]) -> Result<Void, AnyError> {
    return underline.insert(items: items)
  }

  func all() -> Observable<[NewsItemRecord]> {
    return underline.all()
  }

  func record(by id: Int) -> Single<NewsItemRecord?> {
    return underline.record(by: id)
  }

  func clear() -> Result<Void, AnyError> {
    return underline.clear()
  }

  func diskSize() -> Result<Int, AnyError> {
    return underline.diskSize()
  }

  private let underline: NewsItemsDatabaseType

  init() {
    let db = DatabaseFactory.createInMemory()
    do {
      try DatabaseMigrations.migrate(database: db)
    } catch {
      print("error=\(error.localizedDescription)")
    }
    underline = NewsItemsGRDBDatabase(databaseWriter: db)
  }
}
