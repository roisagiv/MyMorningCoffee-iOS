//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

@testable import MyMorningCoffee
import Nimble
import Quick
import RxBlocking
import RxSwift

class TopNewsViewModelSpec: QuickSpec {
  // swiftlint:disable function_body_length, force_try
  override func spec() {
    beforeEach {
      Fixtures.beforeEach()
    }

    afterEach {
      Fixtures.afterEach()
    }

    describe("items") {
      it("should be empty at first") {
        let viewModel = self.createViewModel()
        let items = viewModel.items.asObservable()
        expect(try! items.toBlocking().first()).to(beEmpty())
      }

      it("should not be empty after reload") {
        Fixtures.algoliaHackerNews()

        let viewModel = self.createViewModel()
        let items = viewModel.items.asObservable()
        expect(try! items.toBlocking().first()).to(beEmpty())

        viewModel.refresh.onNext(())
        expect { try items.skip(1).toBlocking(timeout: 1.0).first() }.to(haveCount(500))
      }

      xit("should update after expanding an item") {
        Fixtures.mercuryWebParser()
        Fixtures.algoliaHackerNews()

        let viewModel = self.createViewModel()
        let items = viewModel.items.asObservable()
        expect(try! items.toBlocking().first()).to(beEmpty())

        let id: Int = 17_790_031
        viewModel.refresh.onNext(())
        do {
          expect(try! items.skip(1).toBlocking().first()).to(haveCount(397))
          viewModel.loadItem.onNext(id)

          let updatedItem = try items
            .map {
              $0.first { $0.id == id } ?? TopNewsItem(id: id, title: "NO NO NO")
            }
            .skip(3)
            .toBlocking().first()

          expect(updatedItem?.description) == "Time to break out the tissues, space fans."
        } catch {
          fail(error.localizedDescription)
        }
      }
    }
  }

  private func createViewModel() -> TopNewsViewModelType {
    let sqlite = DatabaseFactory.createInMemory()
    do {
      try DatabaseMigrations.migrate(database: sqlite)
    } catch {}

    let scheduler = MainScheduler.instance

    return TopNewsViewModel(
      hackerNewsService: HackerNewsAlgoliaService(
        provider: MoyaProviderFactory.create(log: false),
        maxConcurrentOperationCount: 5
      ),
      scraperService: MercuryWebParserScraperService(
        provider: MoyaProviderFactory.create(log: false)
      ),
      newsItemDatabase: NewsItemsGRDBDatabase(databaseWriter: sqlite),
      formatter: StubFormatter(),
      scheduler: scheduler
    )
  }
}
