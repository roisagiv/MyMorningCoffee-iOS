//
//  HackerNewsServiceSpecs.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 19/08/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation
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
  }
}
