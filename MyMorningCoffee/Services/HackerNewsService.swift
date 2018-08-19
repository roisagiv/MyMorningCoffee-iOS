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
  let time: Int
  let title: String
  let url: String?
  let type: String
}

protocol HackerNewsService {
  func topNews(size: Int) -> Single<[Int]>
  func story(by id: Int) -> Single<HackerNewsStory>
}
