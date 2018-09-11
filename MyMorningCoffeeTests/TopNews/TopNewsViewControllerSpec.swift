//
//  TopNewsViewControllerSpec.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 08/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

@testable import MyMorningCoffee
import Nimble
import Quick
import RxCocoa
import RxSwift

class TopNewsViewControllerSpec: QuickSpec {
  override func spec() {
    describe("smoke") {
      it("should not fail") {
        let viewModel = StubViewModel()
        let vc = TopNewsViewController.create(viewModel: viewModel, imageLoader: StubImageLoader())
        TestAppDelegate.displayAsRoot(viewController: vc)
        expect(vc).toNot(beNil())
      }
    }
  }

  class StubViewModel: TopNewsViewModelType {
    var refresh: AnyObserver<Void> = PublishSubject<Void>().asObserver()

    var loadItem: AnyObserver<Int> = PublishSubject<Int>().asObserver()

    var items: Driver<[TopNewsItem]>

    init() {
      items = Driver.just([])
    }
  }
}
