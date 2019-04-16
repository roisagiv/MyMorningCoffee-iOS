//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

@testable import MyMorningCoffee
import Nimble
import Nimble_Snapshots
import Quick

class TopNewsCellViewSpec: QuickSpec {
  // swiftlint:disable:next function_body_length
  override func spec() {
    describe("render") {
      var cell: TopNewsCellView!
      let imageLoader = StubImageLoader()
      let sizes = Device.sizes.mapValues { CGSize(width: $0.width, height: TopNewsCellView.height) }

      beforeEach {
        let dataSource = MockDataSource()
        let collectionView = UICollectionView(
          frame: .zero,
          collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(cellType: TopNewsCellView.self)
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        cell = collectionView.dequeueReusableCell(for: IndexPath(row: 0, section: 0), cellType: TopNewsCellView.self)
      }

      it("should display loading state properly") {
        let item = TopNewsItem(
          id: 0,
          title: "HTTPS-Portal: Automated HTTPS server powered by Nginx, Let’s Encrypt and Docker",
          cover: nil,
          url: "https://github.com/SteveLTN/https-portal",
          author: "dhouston",
          description: nil,
          publishedAt: Dates.dateFromISO8601(iso8601: "2018-07-01T21:14:33Z"),
          publishedAtRelative: "",
          source: "",
          sourceFavicon: nil,
          loading: true,
          recordStatus: .empty
        )
        cell.configure(item: item, imageLoader: imageLoader)
        Device.showView(cell)

//        expect(cell).to(recordDynamicSizeSnapshot(sizes: sizes))
        expect(cell).to(haveValidDynamicSizeSnapshot(sizes: sizes))
      }

      it("should display basic state properly") {
        let item = TopNewsItem(
          id: 0,
          title: "HTTPS-Portal: Automated HTTPS server powered by Nginx, Let’s Encrypt and Docker",
          cover: nil,
          url: "https://github.com/SteveLTN/https-portal",
          author: nil,
          description: nil,
          publishedAt: Dates.dateFromISO8601(iso8601: "2018-07-01T21:14:33Z"),
          publishedAtRelative: "",
          source: nil,
          sourceFavicon: nil,
          loading: false,
          recordStatus: .empty
        )
        cell.configure(item: item, imageLoader: imageLoader)
        Device.showView(cell)

//        expect(cell).to(recordDynamicSizeSnapshot(sizes: sizes))
        expect(cell).to(haveValidDynamicSizeSnapshot(sizes: sizes))
      }

      it("should detailed basic state properly") {
        let item = TopNewsItem(
          id: 0,
          title: "HTTPS-Portal: Automated HTTPS server powered by Nginx, Let’s Encrypt and Docker",
          cover: "https://picsum.photos/480/320?image=1084",
          url: "https://github.com/SteveLTN/https-portal",
          author: "dhouston",
          description: """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit,
          sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat
          """,
          publishedAt: Dates.dateFromISO8601(iso8601: "2018-07-01T21:14:33Z"),
          publishedAtRelative: "22 minutes ago",
          source: "wired.com",
          sourceFavicon: nil,
          loading: false,
          recordStatus: .empty
        )
        cell.configure(item: item, imageLoader: imageLoader)
        Device.showView(cell)

//        expect(cell).to(recordDynamicSizeSnapshot(sizes: sizes))
        expect(cell).to(haveValidDynamicSizeSnapshot(sizes: sizes))
      }
    }
  }

  class MockDataSource: NSObject, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
      return 1
    }

    func collectionView(_: UICollectionView,
                        numberOfItemsInSection _: Int) -> Int {
      return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return collectionView.dequeueReusableCell(for: indexPath, cellType: TopNewsCellView.self)
    }
  }
}
