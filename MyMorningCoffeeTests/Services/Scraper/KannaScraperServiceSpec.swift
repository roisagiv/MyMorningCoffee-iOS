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

class KannaScraperServiceSpec: QuickSpec {
  // swiftlint:disable:next function_body_length
  override func spec() {
    beforeEach {
      Fixtures.beforeEach()
    }

    afterEach {
      Fixtures.afterEach()
    }

    describe("scraping") {
      it("parses fast-company") {
        // Arrange
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.absoluteString.contains("http://www.fastcompany.com") == true },
                                 withStubResponse: { _ in
                                   OHHTTPStubsResponse(
                                     fileAtPath: OHPathForFile("fast-company.html", KannaScraperServiceSpec.self)!,
                                     statusCode: 200,
                                     headers: nil
                                   )
        })
        let service = KannaScraperService()

        // Act
        let results = try? service.scrape(
          url: "http://www.fastcompany.com/3060169/one-of-the-biggest-challenges-of-getting-funding-for-minority-owned-business"
        ).toBlocking().first()

        // Assert
        expect(results??.title).to(equal("One Of The Biggest Challenges" +
            " Of Getting Funding For Minority-Owned Business"))
        expect(results??.description).to(equal("Lack of access to capital is a big challenge," +
            " but so is the lack of access to networks and advisors."))
        expect(results??.coverImageUrl).to(equal("http://b.fastcompany.net/multisite_files/fastcompany/imagecache/620x350/poster/2016/05/3060169-poster-p-1-one-of-the-biggest-challenges-of-getting-funding-for-minority-owned-business.jpg"))
        expect(results??.datePublished).to(equal("2016-05-24T21:27:05.000Z"))
        expect(results??.publisher).to(equal("Fast Company"))
        expect(results??.logo).to(equal("http://www.fastcompany.com/favicon.ico"))
        expect(results??.url).to(equal("http://www.fastcompany.com/3060169/one-of-the-biggest-challenges-of-getting-funding-for-minority-owned-business"))
      }

      it("parse bloomberg") {
        // Arrange
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.absoluteString.contains("http://www.bloomberg.com") == true },
                                 withStubResponse: { _ in
                                   OHHTTPStubsResponse(
                                     fileAtPath: OHPathForFile("bloomberg.com.html", KannaScraperServiceSpec.self)!,
                                     statusCode: 200,
                                     headers: nil
                                   )
        })
        let service = KannaScraperService()

        // Act
        let results = try? service.scrape(
          url: "http://www.bloomberg.com/news/articles/2016-05-24/as-zenefits-stumbles-gusto-goes-head-on-by-selling-insurance"
        ).toBlocking().first()

        // Assert
        expect(results??.title).to(equal("As Zenefits Stumbles, Gusto Goes Head-On by Selling Insurance"))
        expect(results??.description).to(equal("The HR startups go to war."))
        expect(results??.coverImageUrl).to(equal("https://assets.bwbx.io/images/users/iqjWHBFdfxIU/ioh_yWEn8gHo/v1/-1x-1.jpg"))
        expect(results??.datePublished).to(equal("2016-05-24T18:00:03.894Z"))
        expect(results??.publisher).to(equal("Bloomberg.com"))
        expect(results??.logo).to(equal("https://assets.bwbx.io/business/public/images/favicons/apple-touch-icon-180x180-c1a237984e.png"))
        expect(results??.url).to(equal("http://www.bloomberg.com/news/articles/2016-05-24/as-zenefits-stumbles-gusto-goes-head-on-by-selling-insurance"))
      }

      pending("parses financial times") {
        // Arrange
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.absoluteString.contains("http://www.ft.com") == true },
                                 withStubResponse: { _ in
                                   OHHTTPStubsResponse(
                                     fileAtPath: OHPathForFile("ft.com.html", KannaScraperServiceSpec.self)!,
                                     statusCode: 200,
                                     headers: nil
                                   )
        })
        let service = KannaScraperService()

        // Act
        let results = try? service.scrape(
          url: "http://www.ft.com/cms/s/2/796d1220-475e-11e5-af2f-4d6e0e5eda22.html"
        ).toBlocking().first()

        // Assert
        expect(results??.title).to(equal("How confidence can help attract funding for women - FT.com"))
        expect(results??.description).to(equal("""
        When she thinks back over the time she spent raising business funding, \
        entrepreneur Lynne Laube remembers meeting only a handful of female venture capitalists. \
        “If you’re a woman out there raising money, you’re going walk into offices dominated by
        """))
        expect(results??.coverImageUrl).to(equal("http://im.ft-static.com/content/images/7badcd14-524c-47d4-8094-b0fd848ff637.img"))
        expect(results??.datePublished).to(equal("2016-02-09T05:01:00.000Z"))
        expect(results??.publisher).to(equal("Financial Times"))
        expect(results??.logo).to(equal("http://im.ft-static.com/m/icons/apple-touch-icon.png"))
        expect(results??.url).to(equal("http://www.ft.com/cms/s/2/796d1220-475e-11e5-af2f-4d6e0e5eda22.html"))
      }

      it("parse forbes") {
        // Arrange
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.absoluteString.contains("http://www.ft.com") == true },
                                 withStubResponse: { _ in
                                   OHHTTPStubsResponse(
                                     fileAtPath: OHPathForFile("forbes.com.html", KannaScraperServiceSpec.self)!,
                                     statusCode: 200,
                                     headers: nil
                                   )
        })
        let service = KannaScraperService()

        // Act
        let results = try? service.scrape(
          url: "http://www.ft.com/cms/s/2/796d1220-475e-11e5-af2f-4d6e0e5eda22.html"
        ).toBlocking().first()

        // Assert
        expect(results??.title).to(equal("Facebook Veteran Grady Burnett Joins HackerRank As COO"))
        expect(results??.description).to(equal("""
        HackerRank, a fast-growing company that runs coding contests to identify top software engineers, \
        has hired Facebook and Google veteran Grady Burnett to be its chief operating officer.
        """))
        expect(results??.coverImageUrl).to(equal("http://blogs-images.forbes.com/georgeanders/files/2015/09/HackerRank-1940x827.jpg"))
        expect(results??.datePublished).to(equal("2015-09-30T15:49:44.000Z"))
        expect(results??.publisher).to(equal("Forbes"))
        expect(results??.author).to(equal("George Anders"))
        expect(results??.logo).to(equal("http://i.forbesimg.com/media/assets/appicons/forbes-app-icon_144x144.png"))
        expect(results??.url).to(equal("http://www.forbes.com/sites/georgeanders/2015/09/30/facebook-veteran-grady-burnett-joins-hackerrank-as-coo/"))
      }
    }
  }
}
