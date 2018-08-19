//
//  HackerNewsHTTPService.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 19/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
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
