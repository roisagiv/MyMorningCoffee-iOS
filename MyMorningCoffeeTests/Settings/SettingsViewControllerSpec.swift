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

class SettingsViewControllerSpec: QuickSpec {
  override func spec() {
    describe("loadView") {
      it("should render correctly") {
        let vc = SettingsViewController.create(
          viewModel: SettingsViewControllerSpec.createViewModel(),
          router: StubRouter()
        )
        Device.showWithAppBar(vc)

//         expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true, tolerance: 0.05))
      }
    }
  }

  class func createViewModel() -> SettingsViewModelType {
    return SettingsViewModel(
      buildIdentity: BuildIdentityService(),
      analyticsService: StubAnalyticsService(),
      database: StubNewsItemDatabase(),
      imageLoader: StubImageLoader()
    )
  }
}
