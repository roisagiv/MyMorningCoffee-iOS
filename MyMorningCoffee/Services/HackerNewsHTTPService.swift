//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Moya
import RxSwift

class HackerNewsHTTPService: HackerNewsService {
  private let provider: MoyaProvider<HackerNewsAPI>
  private let maxConcurrentOperationCount: Int

  init(provider: MoyaProvider<HackerNewsAPI> = MoyaProviderFactory.create(),
       maxConcurrentOperationCount: Int = 5) {
    self.provider = provider
    self.maxConcurrentOperationCount = maxConcurrentOperationCount
  }

  func topNews(size _: Int) -> Single<[Int]> {
    return provider.rx
      .request(.topNews)
      .filterSuccessfulStatusAndRedirectCodes()
      .map([Int].self)
  }

  func story(by id: Int) -> Single<HackerNewsStory> {
    return provider.rx
      .request(.item(id: id))
      .filterSuccessfulStatusAndRedirectCodes()
      .map(HackerNewsStory.self)
  }

  func topStories(size _: Int) -> Single<[HackerNewsStory]> {
    return provider.rx
      .request(.topNews)
      .filterSuccessfulStatusAndRedirectCodes()
      .map([Int].self)
      .map { [unowned self] ids in
        ids.map { self.story(by: $0) }
      }
      .flatMap { requests in
        Single.zip(requests)
      }
  }

  enum HackerNewsAPI {
    case topNews
    case item(id: Int)
  }
}

extension HackerNewsHTTPService.HackerNewsAPI: TargetType {
  var baseURL: URL {
    return URL(string: "https://hacker-news.firebaseio.com")!
  }

  var path: String {
    switch self {
    case .topNews:
      return "v0/topstories.json"
    case let .item(id):
      return "v0/item/\(id).json"
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
    case .topNews, .item:
      return Task.requestPlain
    }
  }

  var headers: [String: String]? {
    return [
      "Content-type": "application/json; charset=UTF-8",
      "Accept": "application/json"
    ]
  }
}
