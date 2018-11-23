//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Fakery
import Foundation
import Nimble
import OHHTTPStubs

class Fixtures {
  class func beforeEach() {
    OHHTTPStubs.onStubMissing {
      if $0.url?.scheme == "file" {
        return
      }
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
          "kids": [17_775_025, 17_775_001, 17_775_142, 17_775_132, 17_774_997, 17_778_590],
          "score": fakery.number.randomInt(min: 10, max: 100),
          "time": 1_534_429_495,
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

  class func algoliaHackerNews() {
    OHHTTPStubs.stubRequests(
      passingTest: {
        $0.url?.relativePath == "/api/v1/search_by_date"
      },
      withStubResponse: { request in
        expect(request.httpMethod).to(equal("GET"))
        expect(request.url?.query).to(contain("tags="))
        expect(request.url?.query).to(contain("hitsPerPage="))

        return OHHTTPStubsResponse(
          fileAtPath: OHPathForFile("hn.algolia.search_by_date.success.json", Fixtures.self)!,
          statusCode: 200,
          headers: nil
        )
      }
    )
  }
}
