//
//  Fixtures.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 23/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Fakery
import Foundation
import Nimble
import OHHTTPStubs

class Fixtures {
  class func beforeEach() {
    OHHTTPStubs.onStubMissing {
      fail("\($0.url?.absoluteString ?? "") was not stubbed")
    }
  }

  class func afterEach() {
    OHHTTPStubs.removeAllStubs()
  }

  class func topStories() {
    OHHTTPStubs.stubRequests(
      passingTest: {
        $0.url?.path == "/v0/topstories.json"
      },
      withStubResponse: { request in

        expect(request.httpMethod).to(equal("GET"))

        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("top-stories.json", Fixtures.self)!,
          statusCode: 200,
          headers: nil
        )
      }
    )
  }

  class func storyItem() {
    let fakery = Faker(locale: "en-US")
    OHHTTPStubs.stubRequests(
      passingTest: {
        $0.url?.path.contains("/v0/item") ?? false
      },
      withStubResponse: { request in
        OHHTTPStubsResponse(jsonObject: [
          "by": "eplanit",
          "descendants": fakery.number.randomInt(),
          "id": Int(request.url?.pathComponents[2] ?? "1") ?? 1,
          "kids": [17775025, 17775001, 17775142, 17775132, 17774997, 17778590],
          "score": fakery.number.randomInt(min: 10, max: 100),
          "time": 1534429495,
          "title": fakery.lorem.sentence(),
          "type": "story",
          "url": fakery.internet.url()
        ], statusCode: 200, headers: nil)
      }
    )
  }

  class func mercuryWebParser() {
    OHHTTPStubs.stubRequests(
      passingTest: {
        $0.url?.relativePath == "/parser"
      },
      withStubResponse: { request in
        expect(request.httpMethod).to(equal("GET"))
        expect(request.url?.query).to(contain("url="))

        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("mercury-response.json", Fixtures.self)!,
          statusCode: 200,
          headers: nil
        )
      }
    )
  }
}
