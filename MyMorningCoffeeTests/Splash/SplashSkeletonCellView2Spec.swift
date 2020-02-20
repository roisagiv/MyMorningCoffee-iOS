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

class SplashSkeletonCellView2Spec: QuickSpec {
  override func spec() {
    let sizes = Device.sizes.mapValues { CGSize(width: $0.width, height: SplashSkeletonCellView2.height) }

    describe("loadView") {
      var cell: SplashSkeletonCellView2!

      beforeEach {
        let dataSource = MockDataSource()
        let collectionView = UICollectionView(
          frame: .zero,
          collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(cellType: SplashSkeletonCellView2.self)
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        cell = collectionView.dequeueReusableCell(
          for: IndexPath(row: 0, section: 0), cellType: SplashSkeletonCellView2.self
        )
      }

      it("renders correctly") {
        Device.showView(cell)

        expect(cell).to(recordDynamicSizeSnapshot(sizes: sizes))
//        expect(cell).to(haveValidDynamicSizeSnapshot(sizes: sizes))
      }
    }
  }

  class MockDataSource: NSObject, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
      return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
      return 1
    }

    func collectionView(
      _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
      return collectionView.dequeueReusableCell(for: indexPath, cellType: SplashSkeletonCellView2.self)
    }
  }
}
