//
//  TopNewsViewModel.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 18/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import RxCocoa
import RxDataSources
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
  let loading: Bool
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
      source: nil,
      loading: false
    )
  }
}

extension TopNewsItem: IdentifiableType {
  var identity: Int {
    return id
  }

  typealias Identity = Int
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
  private let scrapeItemSubject: PublishSubject<NewsItemRecord>

  // MARK: - Outputs

  private(set) lazy var items: Driver<[TopNewsItem]> = {
    newsItemDatabase
      .all()
      .map({ [unowned self] records in
        records.map(self.map)
      })
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
    scrapeItemSubject = PublishSubject<NewsItemRecord>()

    // Refresh

    refreshSubject
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .observeOn(MainScheduler.asyncInstance)
      .flatMap { [unowned self] _ in
        self.hackerNewsService.topStories(size: 500)
      }
      .map {
        $0.map {
          NewsItemRecord(
            id: $0.id,
            time: Date(timeIntervalSince1970: $0.time),
            title: $0.title,
            url: $0.url,
            subTitle: nil,
            imageUrl: nil,
            domain: nil,
            status: NewsItemRecord.Status.fetched
          )
        }
      }
      .map { [unowned self] records in
        self.newsItemDatabase.save(items: records)
      }
      .subscribe()
      .disposed(by: disposeBag)

    loadItemSubject
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .flatMap { [unowned self] (id: Int) -> Single<NewsItemRecord?> in
        self.newsItemDatabase.record(by: id)
      }
      .subscribe(onNext: { [unowned self] record in
        guard var record = record else {
          return
        }
        guard record.url != nil else {
          return
        }
        switch record.status {
        case .fetched:
          record.status = .scraping
          _ = self.newsItemDatabase.save(item: record)
          self.scrapeItemSubject.onNext(record)

        default:
          return
        }
      })
      .disposed(by: disposeBag)

    scrapeItemSubject
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .flatMap { [unowned self] (record: NewsItemRecord) -> Single<(NewsItemRecord, ScrapedItem)> in
        guard let url = record.url else {
          return Single.error(TopNewsViewModelError.recordMissingUrl)
        }
        var scraped = record
        scraped.status = .scraping
        _ = self.newsItemDatabase.save(item: scraped)
        return self.scraperService.scrape(url: url)
          .catchErrorJustReturn(ScrapedItem.empty())
          .map { [scraped] scrapedItem in (scraped, scrapedItem) }
      }
      .materialize()
      .subscribe(onNext: { [unowned self] event in
        switch event {
        case let .next(results):
          var record = results.0
          let scraped = results.1
          let published = moment(scraped.datePublished ?? "")

          record.imageUrl = scraped.coverImageUrl
          record.subTitle = scraped.description
          record.time = published?.date ?? Date()
          record.url = scraped.url
          record.status = .scraped
          _ = self.newsItemDatabase.save(item: record)
        default:
          return
        }
      })
      .disposed(by: disposeBag)
  }

  private func map(record: NewsItemRecord) -> TopNewsItem {
    return TopNewsItem(
      id: record.id,
      title: record.title ?? "",
      cover: record.imageUrl,
      url: record.url,
      author: nil,
      description: record.subTitle,
      publishedAt: record.time,
      source: record.domain,
      loading: [
        NewsItemRecord.Status.fetching,
        NewsItemRecord.Status.scraping
      ].contains(record.status)
    )
  }

  private enum TopNewsViewModelError: Error {
    case recordNotFound
    case recordMissingUrl
    case recordAlreadyScraping
  }
}
