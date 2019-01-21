//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import RxCocoa
import RxDataSources
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
  var refresh: AnyObserver<Void> { get }
  var loadItem: AnyObserver<Int> { get }
  var items: Driver<[TopNewsItem]> { get }
  var loading: Driver<Bool> { get }
}

class TopNewsViewModel: TopNewsViewModelType {
  // MARK: - Inputs

  private(set) lazy var refresh: AnyObserver<Void> = {
    self.refreshSubject.asObserver()
  }()

  private(set) lazy var loadItem: AnyObserver<Int> = {
    self.loadItemSubject.asObserver()
  }()

  private(set) lazy var loading: Driver<Bool> = {
    self.activityIndicator.asDriver()
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
  private let newsItemDatabase: NewsItemsDatabaseType
  private let formatter: Formatter
  private let activityIndicator = ActivityIndicator()
  private let disposeBag: DisposeBag
  private let scheduler: ImmediateSchedulerType

  // swiftlint:disable:next function_body_length
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

    disposeBag = DisposeBag()

    refreshSubject = PublishSubject<Void>()
    loadItemSubject = PublishSubject<Int>()
    scrapeItemSubject = PublishSubject<NewsItemRecord>()

    // Refresh

    refreshSubject
      .trackActivity(activityIndicator)
      .subscribeOn(scheduler)
      .observeOn(scheduler)
      .flatMap { [unowned self] _ -> Single<[HackerNewsStory]> in
        self.hackerNewsService.topStories(size: 500)
      }
      .map {
        $0.map {
          NewsItemRecord(
            id: $0.id,
            time: Date(timeIntervalSince1970: $0.time),
            timeRelative: formatter.relativeFromNow(date: Date(timeIntervalSince1970: $0.time)),
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
        self.newsItemDatabase.insert(items: records)
      }
      .subscribe()
      .disposed(by: disposeBag)

    loadItemSubject
      .observeOn(scheduler)
      .subscribeOn(scheduler)
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
          _ = self.newsItemDatabase.update(item: record)
          self.scrapeItemSubject.onNext(record)

        default:
          return
        }
      })
      .disposed(by: disposeBag)

    scrapeItemSubject
      .observeOn(scheduler)
      .subscribeOn(scheduler)
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
          record.domain = scraped.source
          _ = self.newsItemDatabase.update(item: record)
        default:
          return
        }
      })
      .disposed(by: disposeBag)
  }

  private func map(record: NewsItemRecord) -> TopNewsItem {
    var favicon: String?
    if let domain = record.domain {
      favicon = "https://api.faviconkit.com/\(domain)/64"
    }

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
      sourceFavicon: favicon,
      loading: record.status != .scraped
    )
  }

  private enum TopNewsViewModelError: Error {
    case recordNotFound
    case recordMissingUrl
    case recordAlreadyScraping
  }
}
