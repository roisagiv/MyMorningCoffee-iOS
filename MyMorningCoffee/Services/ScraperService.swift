//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
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
