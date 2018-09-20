//
//  HackerNewsAlgoliaServiceSpec.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 24/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
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
