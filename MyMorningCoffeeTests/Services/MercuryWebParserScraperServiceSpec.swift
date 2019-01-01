//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

@testable import MyMorningCoffee
import Nimble
import OHHTTPStubs
import Quick
import RxBlocking

class MercuryWebParserScraperServiceSpec: QuickSpec {
  override func spec() {
    beforeEach {
      Fixtures.beforeEach()
    }

    afterEach {
      Fixtures.afterEach()
    }

    describe("scrape") {
      it("should return ScrapedItem") {
        Fixtures.mercuryWebParser()
        let service = MercuryWebParserScraperService()

        // Act
        do {
          let response = try service
            .scrape(url: "donno")
            .toBlocking()
            .single()

          expect(response.title).to(equal("An Ode to the Rosetta Spacecraft as It Flings Itself Into a Comet"))
          expect(response.coverImageUrl)
            .to(equal("https://www.wired.com/wp-content/uploads/2016/09/Rosetta_impact-1-1200x630.jpg"))
          expect(response.datePublished).to(equal("2016-09-30T07:00:12.000Z"))
          expect(response.description).to(equal("Time to break out the tissues, space fans."))
          expect(response.source).to(equal("www.wired.com"))
          expect(response.url).to(equal("https://www.wired.com/2016/09/ode-rosetta-spacecraft-going-die-comet/"))
        } catch {
          fail(error.localizedDescription)
        }
      }
    }
  }
}
