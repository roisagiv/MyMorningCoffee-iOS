//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
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
        let vc = TopNewsViewController.create(
          viewModel: viewModel,
          imageLoader: StubImageLoader(),
          formatter: StubFormatter(),
          router: Router()
        )
        Device.showController(vc)
        expect(vc).toNot(beNil())
      }
    }
  }

  class StubViewModel: TopNewsViewModelType {
    var refresh: AnyObserver<Void> = PublishSubject<Void>().asObserver()

    var loading: Driver<Bool> = PublishSubject<Bool>().asDriver(onErrorJustReturn: false)

    var loadItem: AnyObserver<Int> = PublishSubject<Int>().asObserver()

    var items: Driver<[TopNewsItem]>

    init() {
      items = Driver.just([])
    }
  }
}
