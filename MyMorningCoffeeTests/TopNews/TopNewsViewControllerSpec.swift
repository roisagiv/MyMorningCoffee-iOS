//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Action
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
        let vc = TopNewsViewController.create(
          viewModel: viewModel,
          imageLoader: StubImageLoader(),
          formatter: StubFormatter(),
          router: Router()
        )
        Device.showWithAppBar(vc)
        expect(vc).toNot(beNil())
      }
    }
  }

  class StubViewModel: TopNewsViewModelType {
    var refresh: Action<Void, Void> = Action<Void, Void> { _ in .empty() }

    var loading: Driver<Bool> = PublishSubject<Bool>().asDriver(onErrorJustReturn: false)

    var loadItem: Action<Int, Void> = Action<Int, Void> { _ in .empty() }

    var items: Driver<[TopNewsItem]>

    init() {
      items = Driver.just([])
    }
  }
}
