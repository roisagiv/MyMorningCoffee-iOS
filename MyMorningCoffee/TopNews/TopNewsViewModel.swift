//
//  TopNewsViewModel.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 18/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Fakery
import RxSwift

class TopNewsViewModel {
  // MARK: - Models

  struct Item {
    let id: String
    let title: String
    let cover: String?
    let url: String?
    let author: String?
    let description: String?
    let publishedAt: Date?
    let source: String?
  }

  // MARK: - Inputs

  let reload: AnyObserver<Void>

  // MARK: - Outputs

  let items: Observable<[TopNewsViewModel.Item]>

  // MARK: - Implementation

  init() {
    let reloadSubject = PublishSubject<Void>()
    reload = reloadSubject.asObserver()

    items = reloadSubject.map { _ in
      let faker = Faker(locale: "en-US")
      return Array(0 ... 39).map { _ in Item(
        id: faker.lorem.characters(amount: 10),
        title: faker.lorem.sentences(),
        cover: "https://picsum.photos/640/480/?image=\(faker.number.randomInt(min: 0, max: 1000))",
        url: faker.internet.url(),
        author: faker.name.name(),
        description: faker.lorem.paragraph(),
        publishedAt: faker.business.creditCardExpiryDate(),
        source: faker.internet.domainName()
      ) }
    }
  }
}
