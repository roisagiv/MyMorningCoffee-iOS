//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import RxSwift

struct HackerNewsStory: Decodable {
  let id: Int
  let time: Double
  let title: String
  let url: String?
  let type: String

  init(id: Int, time: Double, title: String, url: String?, type: String) {
    self.id = id
    self.time = time
    self.title = title
    self.url = url
    self.type = type
  }
}

protocol HackerNewsService {
  func topNews(size: Int) -> Single<[Int]>
  func story(by id: Int) -> Single<HackerNewsStory>
  func topStories(size: Int) -> Single<[HackerNewsStory]>
}
