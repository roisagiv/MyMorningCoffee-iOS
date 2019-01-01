//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Keys
import Moya
import RxSwift

private struct MercuryWebParserResponse: Decodable {
  let title: String?
  let datePublished: String?
  let leadImageUrl: String?
  let url: String?
  let domain: String?
  let excerpt: String?

  private enum CodingKeys: String, CodingKey {
    case title
    case url
    case domain
    case excerpt
    case datePublished = "date_published"
    case leadImageUrl = "lead_image_url"
  }
}

class MercuryWebParserScraperService: ScraperService {
  private let provider: MoyaProvider<API>

  init(provider: MoyaProvider<API> = MoyaProviderFactory.create()) {
    self.provider = provider
  }

  func scrape(url: String) -> Single<ScrapedItem> {
    return provider.rx
      .request(.parser(url: url))
      .filterSuccessfulStatusAndRedirectCodes()
      .map(MercuryWebParserResponse.self)
      .map {
        ScrapedItem(
          source: $0.domain,
          description: $0.excerpt,
          url: $0.url,
          coverImageUrl: $0.leadImageUrl,
          datePublished: $0.datePublished,
          title: $0.title
        )
      }
  }

  enum API {
    case parser(url: String)
  }
}

extension MercuryWebParserScraperService.API: TargetType {
  var baseURL: URL {
    return URL(string: "https://mercury.postlight.com")!
  }

  var path: String {
    switch self {
    case .parser:
      return "parser"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case let .parser(url):
      return Task.requestParameters(
        parameters: ["url": url],
        encoding: URLEncoding.queryString
      )
    }
  }

  var headers: [String: String]? {
    return ["x-api-key": MyMorningCoffeeKeys().mercuryWebParserKey]
  }
}
