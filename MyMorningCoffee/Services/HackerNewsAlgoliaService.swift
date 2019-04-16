//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Moya
import RxSwift

class HackerNewsAlgoliaService: HackerNewsService {
  private let provider: MoyaProvider<API>
  private let maxConcurrentOperationCount: Int

  init(provider: MoyaProvider<API> = MoyaProviderFactory.create(),
       maxConcurrentOperationCount: Int = 5) {
    self.provider = provider
    self.maxConcurrentOperationCount = maxConcurrentOperationCount
  }

  func topNews(size _: Int) -> Single<[Int]> {
    return Single.never()
  }

  func story(by _: Int) -> Single<HackerNewsStory> {
    return Single.never()
  }

  func topStories(size: Int) -> Single<[HackerNewsStory]> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Dates.iso8601Full)
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return provider.rx
      .request(.searchByDate(size: size))
      .filterSuccessfulStatusAndRedirectCodes()
      .map(SearchByDateResponse.self, using: decoder)
      .map { (response: SearchByDateResponse) -> [HackerNewsStory] in
        response.hits.map {
          HackerNewsStory(
            id: Int($0.objectID) ?? 0,
            time: $0.createdAt?.timeIntervalSince1970 ?? 0,
            title: $0.title ?? "",
            url: $0.url,
            type: $0.type
          )
        }
      }
  }

  enum API {
    case searchByDate(size: Int)
  }

  struct SearchByDateResponse: Decodable {
    let hits: [SearchByDateHit]
  }

  struct SearchByDateHit: Decodable {
    let title: String?
    let url: String?
    let objectID: String
    let author: String?
    let createdAt: Date?
    let type: String = "story"
  }
}

extension HackerNewsAlgoliaService.API: TargetType {
  var baseURL: URL {
    return URL(string: "https://hn.algolia.com/api/v1")!
  }

  var path: String {
    switch self {
    case .searchByDate:
      return "search_by_date"
    }
  }

  var method: Moya.Method {
    switch self {
    case .searchByDate:
      return .get
    }
  }

  var task: Task {
    switch self {
    case let .searchByDate(size):
      return .requestParameters(
        parameters: ["tags": "story", "hitsPerPage": size],
        encoding: URLEncoding.queryString
      )
    }
  }

  var sampleData: Data {
    return Data()
  }

  var headers: [String: String]? {
    return [:]
  }
}
