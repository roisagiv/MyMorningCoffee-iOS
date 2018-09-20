//
//  ScraperService.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 20/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import RxSwift

struct ScrapedItem {
  let source: String?
  let description: String?
  let url: String?
  let coverImageUrl: String?
  let datePublished: String?
  let title: String?
}

extension ScrapedItem {
  static func empty() -> ScrapedItem {
    return ScrapedItem(
      source: nil,
      description: nil,
      url: nil,
      coverImageUrl: nil,
      datePublished: nil,
      title: nil
    )
  }
}

protocol ScraperService {
  func scrape(url: String) -> Single<ScrapedItem>
}
