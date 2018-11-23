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
import RxNimble
import RxSwift

class TopNewsViewModelSpec: QuickSpec {
  // swiftlint:disable:next function_body_length
  override func spec() {
    beforeEach {
      Fixtures.beforeEach()

      do {
        try Injector.configure()
        try DatabaseMigrations.migrate(database: Injector.databaseWriter)
      } catch {
        fail(error.localizedDescription)
      }
    }

    afterEach {
      Fixtures.afterEach()
    }

    describe("items") {
      it("should be empty at first") {
        let viewModel = self.createViewModel()
        let items = viewModel.items.asObservable()
        expect(items).first.to(beEmpty())
      }

      it("should not be empty after reload") {
        Fixtures.algoliaHackerNews()

        let viewModel = self.createViewModel()
        let items = viewModel.items.asObservable()
        expect(items).first.to(beEmpty())

        viewModel.refresh.onNext(())
        expect(items.skip(1)).first.to(haveCount(500))
      }

      xit("should update after expanding an item") {
        Fixtures.topStories()
        Fixtures.storyItem()
        Fixtures.mercuryWebParser()

        let viewModel = self.createViewModel()
        let items = viewModel.items.asObservable()
        expect(items).first.to(beEmpty())

        let id: Int = 17_790_031
        viewModel.refresh.onNext(())
        do {
          expect(items.skip(1)).first.to(haveCount(397))
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
    return TopNewsViewModel(
      hackerNewsService: HackerNewsAlgoliaService(
        provider: MoyaProviderFactory.create(log: false),
        maxConcurrentOperationCount: 5
      ),
      scraperService: MercuryWebParserScraperService(
        provider: MoyaProviderFactory.create(log: false)
      ),
      newsItemDatabase: NewsItemsGRDBDatabase(databaseWriter: sqlite),
      formatter: StubFormatter()
    )
  }
}
