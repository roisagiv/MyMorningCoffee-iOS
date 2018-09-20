//
//  HackerNewsService.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 19/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
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
