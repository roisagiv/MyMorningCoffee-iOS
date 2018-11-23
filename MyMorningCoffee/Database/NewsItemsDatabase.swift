//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation
import GRDB
import Result
import RxGRDB
import RxSwift

protocol NewsItemsDatabase {
  func save(item: NewsItemRecord) -> Result<Void, AnyError>
  func save(items: [NewsItemRecord]) -> Result<Void, AnyError>
  func all() -> Observable<[NewsItemRecord]>
  func record(by id: Int) -> Single<NewsItemRecord?>
}

class NewsItemsGRDBDatabase: NewsItemsDatabase {
  private let databaseWriter: DatabaseWriter

  init(databaseWriter: DatabaseWriter) {
    self.databaseWriter = databaseWriter
  }

  func save(item: NewsItemRecord) -> Result<Void, AnyError> {
    do {
      try databaseWriter.write { [item] database in
        try item.save(database)
      }
      return .success(())
    } catch {
      return .failure(AnyError(error))
    }
  }

  func save(items: [NewsItemRecord]) -> Result<Void, AnyError> {
    do {
      try databaseWriter.write { [items] database in
        try items.forEach {
          try $0.save(database)
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
}
