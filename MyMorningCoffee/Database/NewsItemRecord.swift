//
//  NewsItemRecord.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 21/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB

struct NewsItemRecord: Codable {
  let id: Int
  var time: Date
  var title: String?
  var url: String?
  var subTitle: String?
  var imageUrl: String?
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
      title: nil,
      url: nil,
      subTitle: nil,
      imageUrl: nil,
      domain: nil,
      status: .empty
    )
  }
}

extension NewsItemRecord: FetchableRecord, PersistableRecord, TableRecord {
  public static var databaseTableName = "newsItem"

  enum Columns: String, ColumnExpression {
    case id
    case time
    case title
    case subTitle
    case url
    case imageUrl
    case domain
    case status
  }
}
