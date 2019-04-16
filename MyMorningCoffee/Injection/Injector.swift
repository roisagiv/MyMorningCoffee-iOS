//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Firebase
import GRDB
import Keys
import RxSwift
import Swinject

class Injector {
  static var topNewsViewModel: TopNewsViewModelType {
    let operationQueue = OperationQueue()
    operationQueue.qualityOfService = .userInteractive
    operationQueue.name = String(describing: TopNewsViewModel.self)
    operationQueue.maxConcurrentOperationCount = 5
    let scheduler = OperationQueueScheduler(
      operationQueue: operationQueue
    )

    return TopNewsViewModel(
      hackerNewsService: assembler.resolver.resolve(HackerNewsService.self)!,
      scraperService: assembler.resolver.resolve(ScraperService.self)!,
      newsItemDatabase: assembler.resolver.resolve(NewsItemsDatabaseType.self)!,
      formatter: assembler.resolver.resolve(Formatter.self)!,
      scheduler: scheduler
    )
  }

  static var settingsViewModel: SettingsViewModelType {
    return SettingsViewModel(
      buildIdentity: assembler.resolver.resolve(BuildIdentityServiceType.self)!,
      analyticsService: analyticsService,
      database: assembler.resolver.resolve(NewsItemsDatabaseType.self)!,
      imageLoader: imageLoader
    )
  }

  static var databaseWriter: DatabaseWriter {
    return assembler.resolver.resolve(DatabaseWriter.self)!
  }

  static var imageLoader: ImageLoaderType {
    return assembler.resolver.resolve(ImageLoaderType.self)!
  }

  static var formatter: Formatter {
    return assembler.resolver.resolve(Formatter.self)!
  }

  static var router: Router {
    return assembler.resolver.resolve(Router.self)!
  }

  static var analyticsService: AnalyticsService {
    return assembler.resolver.resolve(AnalyticsService.self)!
  }

  static var remoteConfig: RemoteConfigType {
    return assembler.resolver.resolve(RemoteConfigType.self)!
  }

  class func initialize() {
    assembler.apply(assembly: PreConfigAssembly())
  }

  class func configure(remoteConfig _: RemoteConfigType) {
    assembler.apply(assembly: PostConfigAssembly())
  }

  private static var assembler: Assembler = Assembler()
}
