//
//  TopNewsViewModel.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 18/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMoment

struct TopNewsItem {
  let id: Int
  let title: String
  let cover: String?
  let url: String?
  let author: String?
  let description: String?
  let publishedAt: Date?
  let source: String?
}

extension TopNewsItem {
  init(id: Int, title: String) {
    self.init(
      id: id,
      title: title,
      cover: nil,
      url: nil,
      author: nil,
      description: nil,
      publishedAt: nil,
      source: nil
    )
  }
}

protocol TopNewsViewModelType {
  var refresh: AnyObserver<Void> { get }
  var loadItem: AnyObserver<Int> { get }
  var items: Driver<[TopNewsItem]> { get }
}

class TopNewsViewModel: TopNewsViewModelType {
  // MARK: - Inputs

  private(set) lazy var refresh: AnyObserver<Void> = {
    self.refreshSubject.asObserver()
  }()

  private(set) lazy var loadItem: AnyObserver<Int> = {
    self.loadItemSubject.asObserver()
  }()

  private let refreshSubject: PublishSubject<Void>
  private let loadItemSubject: PublishSubject<Int>

  // MARK: - Outputs

  private(set) lazy var items: Driver<[TopNewsItem]> = {
    newsItemDatabase.all()
      .map { items in
        items.map { TopNewsItem(
          id: $0.id,
          title: $0.title ?? "",
          cover: $0.imageUrl,
          url: $0.url,
          author: nil,
          description: $0.subTitle,
          publishedAt: nil,
          source: $0.domain
        ) }
      }
      .share()
      .asDriver(onErrorJustReturn: [])
  }()

  // MARK: - Implementation

  private let hackerNewsService: HackerNewsService
  private let scraperService: ScraperService
  private let newsItemDatabase: NewsItemsDatabase
  private let disposeBag: DisposeBag

  init(
    hackerNewsService: HackerNewsService,
    scraperService: ScraperService,
    newsItemDatabase: NewsItemsDatabase
  ) {
    self.hackerNewsService = hackerNewsService
    self.scraperService = scraperService
    self.newsItemDatabase = newsItemDatabase

    disposeBag = DisposeBag()

    refreshSubject = PublishSubject<Void>()
    loadItemSubject = PublishSubject<Int>()

    // Refresh

    refreshSubject
      .subscribe { [unowned self] _ in
        self.hackerNewsService.topNews(size: 50)
          .map { $0.map { NewsItemRecord(id: $0) } }
          .map { [unowned self] records in
            return self.newsItemDatabase.save(items: records)
          }
          .subscribe()
          .disposed(by: self.disposeBag)
      }
      .disposed(by: disposeBag)

    // Load Item
    loadItemSubject.subscribe(onNext: { [unowned self] id in
      self.newsItemDatabase
        .record(by: id)
        .flatMapFirst { [unowned self] record in
          return self.expand(record: record)
        }
        .subscribe()
        .disposed(by: self.disposeBag)
    }).disposed(by: disposeBag)
  }

  private func expand(record: NewsItemRecord?) -> Observable<NewsItemRecord> {
    guard let record = record else {
      return Observable.empty()
    }
    switch record.status {
    case .empty:
      return hackerNewsService
        .story(by: record.id)
        .flatMap { [unowned self] story in
          let newRecord = NewsItemRecord(
            id: record.id,
            time: record.time,
            title: story.title,
            subTitle: nil,
            url: story.url,
            imageUrl: nil,
            domain: nil,
            status: .fetched
          )
          switch self.newsItemDatabase.save(item: newRecord) {
          case .success:
            return self.scarpe(record: newRecord)
          case let .failure(error):
            return Single.error(error)
          }
        }
        .asObservable()
    default:
      return Observable.just(record)
    }
  }

  private func scarpe(record: NewsItemRecord) -> Single<NewsItemRecord> {
    guard let url = record.url else {
      return Single.just(record)
    }

    return scraperService.scrape(url: url)
      .flatMap { [unowned self] item in
        let published = moment(item.datePublished ?? "")

        let newRecord = NewsItemRecord(
          id: record.id,
          time: published?.date ?? Date(),
          title: item.title,
          subTitle: item.description,
          url: item.url,
          imageUrl: item.coverImageUrl,
          domain: item.source,
          status: .scraped
        )

        switch self.newsItemDatabase.save(item: newRecord) {
        case .success:
          return Single.just(newRecord)
        case let .failure(error):
          return Single.error(error)
        }
      }
  }
}
