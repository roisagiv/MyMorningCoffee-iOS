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

class HackerNewsAlgoliaServiceSpec: QuickSpec {
  override func spec() {
    describe("searchByDate") {
      beforeEach {
        Fixtures.beforeEach()
      }

      afterEach {
        Fixtures.afterEach()
      }

      it("returns list of stories") {
        let size = 500

        let service = HackerNewsAlgoliaService()

        Fixtures.algoliaHackerNews()

        do {
          let stories = try service
            .topStories(size: size)
            .toBlocking()
            .first()!
          expect(stories).to(haveCount(size))
          expect(stories).to(allPass { (story: HackerNewsStory?) -> Bool in
            story!.id > 0 && story!.time > 0.0
          })
        } catch {
          fail(error.localizedDescription)
        }
      }
    }
  }
}
