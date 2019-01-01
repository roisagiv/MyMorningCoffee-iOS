//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import GRDB
import Swinject

class PostConfigAssembly: Assembly {
  func assemble(container: Container) {
    let log = Environment.log

    // HackerNewsService
    container.register(HackerNewsService.self) { _ in
      return HackerNewsAlgoliaService(
        provider: MoyaProviderFactory.create(log: log),
        maxConcurrentOperationCount: 15
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

    // ImageLoader
    container.register(ImageLoader.self) { _ in NukeImageLoader() }

    // Formatter
    container.register(Formatter.self) { _ in DefaultFormatter() }

    // Analytics
    container.register(AnalyticsService.self) { resolver in
      let analyticsService = FirebaseAnalyticsService()

      let remoteConfig = resolver.resolve(RemoteConfigType.self)
      analyticsService.setEnabled(remoteConfig?.analyticsEnabled ?? false)

      return analyticsService
    }
  }
}
