//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import AlamofireNetworkActivityLogger
import GRDB
import Swinject

class Injector {
  static var topNewsViewModel: TopNewsViewModelType {
    return TopNewsViewModel(
      hackerNewsService: container.resolve(HackerNewsService.self)!,
      scraperService: container.resolve(ScraperService.self)!,
      newsItemDatabase: container.resolve(NewsItemsDatabase.self)!,
      formatter: container.resolve(Formatter.self)!
    )
  }

  static var databaseWriter: DatabaseWriter {
    return container.resolve(DatabaseWriter.self)!
  }

  static var imageLoader: ImageLoader {
    return container.resolve(ImageLoader.self)!
  }

  static var formatter: Formatter {
    return container.resolve(Formatter.self)!
  }

  static var router: Router {
    return container.resolve(Router.self)!
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
        return HackerNewsAlgoliaService(
          provider: MoyaProviderFactory.create(log: log),
          maxConcurrentOperationCount: 5
        )
      }

      // ScraperService
      container.register(ScraperService.self) { _ in
        return MercuryWebParserScraperService(
          provider: MoyaProviderFactory.create(log: log)
        )
      }

      // NewsItemsDatabase
      container.register(NewsItemsDatabase.self) { resolver in
        return NewsItemsGRDBDatabase(databaseWriter: resolver.resolve(DatabaseWriter.self)!)
      }

      // DatabaseWriter
      container.register(DatabaseWriter.self) { _ in
        /*
         do {
         return try DatabaseFactory.create(log: log)
         } catch {
         return DatabaseFactory.createInMemory(log: log)
         }
         */
        return DatabaseFactory.createInMemory(log: log)
      }.inObjectScope(ObjectScope.container)

      // ImageLoader
      container.register(ImageLoader.self) { _ in NukeImageLoader() }

      // Formatter
      container.register(Formatter.self) { _ in DefaultFormatter() }

      // Router
      container.register(Router.self) { _ in Router() }
    }
  }
}
