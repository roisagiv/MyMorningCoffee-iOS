//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Action
import Result
import RxCocoa
import RxDataSources
import RxOptional
import RxSwift
import RxSwiftUtilities
import SwiftMoment

struct TopNewsItem {
  let id: Int
  let title: String
  let cover: String?
  let url: String?
  let author: String?
  let description: String?
  let publishedAt: Date?
  let publishedAtRelative: String?
  let source: String?
  let sourceFavicon: String?
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
      publishedAtRelative: nil,
      source: nil,
      sourceFavicon: nil,
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
  var refresh: Action<Void, Void> { get }
  var loadItem: Action<Int, Void> { get }
  var items: Driver<[TopNewsItem]> { get }
  var loading: Driver<Bool> { get }
}

class TopNewsViewModel: TopNewsViewModelType {
  // MARK: - Inputs

  // refresh
  lazy var refresh: Action<Void, Void> = {
    Action<Void, Void> { [unowned self] _ in
      self.hackerNewsService
        .topStories(size: 500)
        .trackActivity(self.activityIndicator)
        .observeOn(self.scheduler)
        .map { [unowned self] stories in
          stories.map {
            NewsItemRecord(
              id: $0.id,
              time: Date(timeIntervalSince1970: $0.time),
              timeRelative: self.formatter.relativeFromNow(date: Date(timeIntervalSince1970: $0.time)),
              title: $0.title,
              url: $0.url,
              subTitle: nil,
              imageUrl: nil,
              logoUrl: nil,
              author: nil,
              domain: nil,
              status: NewsItemRecord.Status.fetched
            )
          }
        }
        .flatMap { [unowned self] (records: [NewsItemRecord]) -> Observable<Void> in
          switch self.newsItemDatabase.insert(items: records) {
          case .success:
            return .empty()
          case let .failure(error):
            return Observable.error(error)
          }
        }
    }
  }()

  lazy var loadItem: Action<Int, Void> = {
    Action<Int, Void> { [unowned self] (id: Int) -> Observable<Void> in
      self.newsItemDatabase.record(by: id)
        .observeOn(self.scheduler)
        .asObservable()
        .filterNil()
        .filter { [unowned self] record in
          guard record.url != nil else {
            return false
          }
          return record.status == .fetched
        }
        .do(onNext: { [unowned self] record in
          var record = record
          record.status = .scraping
          _ = self.newsItemDatabase.update(item: record)
        })
        .flatMap { [unowned self] (record: NewsItemRecord) -> Single<(NewsItemRecord, ScrapedItem)> in
          guard let url = record.url else {
            return Single.error(TopNewsViewModelError.recordMissingUrl)
          }
          var scraped = record
          scraped.status = .scraping
          _ = self.newsItemDatabase.update(item: scraped)
          return self.scraperService.scrape(url: url)
            .catchErrorJustReturn(ScrapedItem.empty())
            .map { [scraped] scrapedItem in (scraped, scrapedItem) }
        }
        .materialize()
        .do(onNext: { [unowned self] event in
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
            record.domain = scraped.publisher
            record.logoUrl = scraped.logo
            record.author = scraped.author
            _ = self.newsItemDatabase.update(item: record)
          default:
            return
          }
        })
        .map { _ in () }
    }
  }()

  private(set) lazy var loading: Driver<Bool> = {
    self.activityIndicator.asDriver()
  }()

  // MARK: - Outputs

  private(set) lazy var items: Driver<[TopNewsItem]> = {
    newsItemDatabase
      .all()
      .map { [unowned self] records in
        records.map(self.map)
      }
      .share()
      .asDriver(onErrorJustReturn: [])
  }()

  // MARK: - Implementation

  private let hackerNewsService: HackerNewsService
  private let scraperService: ScraperService
  private let newsItemDatabase: NewsItemsDatabaseType
  private let formatter: Formatter
  private let activityIndicator = ActivityIndicator()
  private let scheduler: ImmediateSchedulerType

  init(
    hackerNewsService: HackerNewsService,
    scraperService: ScraperService,
    newsItemDatabase: NewsItemsDatabaseType,
    formatter: Formatter,
    scheduler: ImmediateSchedulerType
  ) {
    self.hackerNewsService = hackerNewsService
    self.scraperService = scraperService
    self.newsItemDatabase = newsItemDatabase
    self.formatter = formatter
    self.scheduler = scheduler
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
      publishedAtRelative: record.timeRelative,
      source: record.domain,
      sourceFavicon: record.logoUrl,
      loading: record.status != .scraped
    )
  }

  private enum TopNewsViewModelError: Error {
    case recordNotFound
    case recordMissingUrl
    case recordAlreadyScraping
  }
}
