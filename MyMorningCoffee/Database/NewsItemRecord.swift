//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import GRDB

struct NewsItemRecord: Codable {
  let id: Int
  var time: Date
  var timeRelative: String?
  var title: String?
  var url: String?
  var subTitle: String?
  var imageUrl: String?
  var logoUrl: String?
  var author: String?
  var domain: String?
  var status: Status

  enum Status: String, Codable {
    case empty
    case fetching
    case fetched
    case scraping
    case scraped
    case error
  }
}

extension NewsItemRecord {
  init(id: Int) {
    self.init(
      id: id,
      time: Date(),
      timeRelative: nil,
      title: nil,
      url: nil,
      subTitle: nil,
      imageUrl: nil,
      logoUrl: nil,
      author: nil,
      domain: nil,
      status: .empty
    )
  }
}

extension NewsItemRecord: FetchableRecord, PersistableRecord, MutablePersistableRecord {
  public static var databaseTableName = "newsItem"

  enum Columns: String, ColumnExpression {
    case id
    case time
    case timeRelative
    case title
    case subTitle
    case url
    case imageUrl
    case logoUrl
    case author
    case domain
    case status
  }

  static var persistenceConflictPolicy = PersistenceConflictPolicy(
    insert: .ignore, update: .replace
  )
}
