//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation
import GRDB
import Result
import RxGRDB
import RxSwift

protocol NewsItemsDatabaseType {
  func update(item: NewsItemRecord) -> Result<Void, AnyError>
  func insert(items: [NewsItemRecord]) -> Result<Void, AnyError>
  func all() -> Observable<[NewsItemRecord]>
  func record(by id: Int) -> Single<NewsItemRecord?>
  func clear() -> Result<Void, AnyError>
  func diskSize() -> Result<Int, AnyError>
}

class NewsItemsGRDBDatabase: NewsItemsDatabaseType {
  private let databaseWriter: DatabaseWriter

  init(databaseWriter: DatabaseWriter) {
    self.databaseWriter = databaseWriter
  }

  func update(item: NewsItemRecord) -> Result<Void, AnyError> {
    do {
      try databaseWriter.write { [item] database in
        try item.update(database)
      }
      return .success(())
    } catch {
      return .failure(AnyError(error))
    }
  }

  func insert(items: [NewsItemRecord]) -> Result<Void, AnyError> {
    do {
      try databaseWriter.write { [items] database in
        try items.forEach {
          try $0.insert(database)
        }
      }
      return .success(())
    } catch {
      return .failure(AnyError(error))
    }
  }

  func all() -> Observable<[NewsItemRecord]> {
    return NewsItemRecord.order(NewsItemRecord.Columns.id.desc)
      .rx
      .fetchAll(in: databaseWriter)
  }

  func record(by id: Int) -> Single<NewsItemRecord?> {
    return NewsItemRecord.filter(key: id).rx.fetchOne(in: databaseWriter)
      .take(1)
      .asSingle()
  }

  func clear() -> Result<Void, AnyError> {
    do {
      _ = try databaseWriter.write { database in
        try NewsItemRecord.deleteAll(database)
      }
      return .success(())
    } catch {
      return .failure(AnyError(error))
    }
  }

  func diskSize() -> Result<Int, AnyError> {
    do {
      let size: Int = try databaseWriter.read { database in
        if let row = try Row.fetchOne(
          database,
          "SELECT page_count * page_size as size FROM pragma_page_count(), pragma_page_size();"
        ) {
          return row["size"] as Int
        } else {
          return 0
        }
      }
      return Result.success(size)
    } catch {
      return .failure(AnyError(error))
    }
  }
}
