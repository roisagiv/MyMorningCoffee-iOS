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
  let time: Date
  let title: String?
  let subTitle: String?
  let url: String?
  let imageUrl: String?
  let domain: String?
  let status: Status

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
      subTitle: nil,
      url: nil,
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
