//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import RxSwift

struct ScrapedItem {
  let publisher: String?
  let description: String?
  let url: String?
  let coverImageUrl: String?
  let datePublished: String?
  let title: String?
  let logo: String?
  let author: String?
}

extension ScrapedItem {
  static func empty() -> ScrapedItem {
    return ScrapedItem(
      publisher: nil,
      description: nil,
      url: nil,
      coverImageUrl: nil,
      datePublished: nil,
      title: nil,
      logo: nil,
      author: nil
    )
  }
}

protocol ScraperService {
  func scrape(url: String) -> Single<ScrapedItem>
}
