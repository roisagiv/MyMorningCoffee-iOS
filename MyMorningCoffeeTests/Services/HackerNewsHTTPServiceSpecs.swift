//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation
import Moya
@testable import MyMorningCoffee
import Nimble
import OHHTTPStubs
import Quick
import RxBlocking
import RxSwift

class HackerNewsServiceHTTPSpecs: QuickSpec {
  override func spec() {
    beforeEach {
      Fixtures.beforeEach()
    }

    afterEach {
      Fixtures.afterEach()
    }

    describe("topNews") {
      it("returns empty stories") {
        // Arrange
        let service = HackerNewsHTTPService()
        Fixtures.topStories()

        // Act
        expect {
          try service
            .topNews(size: 397)
            .toBlocking()
            .first()
        }.to(haveCount(397))
      }
    }

    describe("topStories") {
      it("returns list of stories") {
        let service = HackerNewsHTTPService()
        Fixtures.topStories()
        Fixtures.storyItem()
        expect {
          try service
            .topStories(size: 397)
            .toBlocking()
            .first()
        }.to(haveCount(397))
      }
    }
  }
}
