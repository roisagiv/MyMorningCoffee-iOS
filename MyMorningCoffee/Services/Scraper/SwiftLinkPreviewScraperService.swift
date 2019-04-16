//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import RxSwift
import SwiftLinkPreview

class SwiftLinkPreviewScraperService: ScraperService {
  private let slp: SwiftLinkPreview
  init() {
    slp = SwiftLinkPreview()
  }

  func scrape(url: String) -> Single<ScrapedItem> {
    return Single<ScrapedItem>.create { [weak self] observer in
      let preview = self?.slp.preview(url,
                                      onSuccess: { response in
                                        let item: ScrapedItem = ScrapedItem(
                                          publisher: response.canonicalUrl,
                                          description: response.description,
                                          url: response.finalUrl?.absoluteString,
                                          coverImageUrl: response.image,
                                          datePublished: nil,
                                          title: response.title,
                                          logo: nil,
                                          author: nil
                                        )

                                        observer(.success(item))
                                      },
                                      onError: { observer(.error($0)) })
      return Disposables.create {
        preview?.cancel()
      }
    }
  }
}
