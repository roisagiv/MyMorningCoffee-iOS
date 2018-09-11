//
//  Injector.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 23/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import AlamofireNetworkActivityLogger
import GRDB
import Swinject

class Injector {
  static var topNewsViewModel: TopNewsViewModelType {
    return TopNewsViewModel(
      hackerNewsService: container.resolve(HackerNewsService.self)!,
      scraperService: container.resolve(ScraperService.self)!,
      newsItemDatabase: container.resolve(NewsItemsDatabase.self)!
    )
  }

  static var databaseWriter: DatabaseWriter {
    return container.resolve(DatabaseWriter.self)!
  }

  static var imageLoader: ImageLoader {
    return container.resolve(ImageLoader.self)!
  }

  /* testable */ static var container: Container = Container()

  class func configure() throws {
    let log = Environment.log

    if log {
      NetworkActivityLogger.shared.startLogging()
      NetworkActivityLogger.shared.level = .debug
    }

    container = Container { container in
      // HackerNewsService
      container.register(HackerNewsService.self) { _ in
        return HackerNewsHTTPService(
          provider: MoyaProviderFactory.create(log: log),
          maxConcurrentOperationCount: 5
        )
      }

      // ScraperService
      container.register(ScraperService.self) { _ in
        return MercuryWebParserScraperService(
          provider: MoyaProviderFactory.create(log: false)
        )
      }

      // NewsItemsDatabase
      container.register(NewsItemsDatabase.self) { resolver in
        return NewsItemsGRDBDatabase(databaseWriter: resolver.resolve(DatabaseWriter.self)!)
      }

      // DatabaseWriter
      container.register(DatabaseWriter.self) { _ in
        DatabaseFactory.create(log: log)
      }.inObjectScope(ObjectScope.container)

      // ImageLoader
      container.register(ImageLoader.self) { _ in KingfisherImageLoader() }
    }
  }
}
