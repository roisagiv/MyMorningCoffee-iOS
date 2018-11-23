//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

@testable import MyMorningCoffee
import Nimble
import Nimble_Snapshots
import Quick

class NewsItemViewControllerSpec: QuickSpec {
  override func spec() {
    describe("loading url") {
      it("should display the content") {
        let url = Bundle(for: type(of: self)).url(forResource: "Hurricane-Utah-Wikipedia", withExtension: "html")
        let vc = NewsItemViewController.create(
          url: url!,
          title: "Lorem Ipsum"
        )
        TestAppDelegate.displayAsRoot(viewController: vc)
        expect(vc.finishLoading).toEventually(beTrue(), timeout: 20)
        RunLoop.main.run(until: Date().addingTimeInterval(0.5))

//        expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
      }
    }
  }
}
