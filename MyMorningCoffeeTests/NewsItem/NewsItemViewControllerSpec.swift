//
//  NewsItemViewControllerSpec.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 11/11/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
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
        expect(vc.finishLoading).toEventually(beTrue(), timeout: 5)
        RunLoop.main.run(until: Date().addingTimeInterval(0.5))

//        expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
      }
    }
  }
}
