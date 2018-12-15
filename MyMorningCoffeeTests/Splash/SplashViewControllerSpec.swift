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

class SplashViewControllerSpec: QuickSpec {
  override func spec() {
    describe("loadView") {
      it("should render correctly") {
        let router = StubRouter()
        let removeConfig = StubRemoteConfig()
        let db = DatabaseFactory.createInMemory(log: false)

        do {
          try DatabaseMigrations.migrate(database: db)
        } catch {
          fail(error.localizedDescription)
        }

        let vc = SplashViewController.create(
          router: router,
          remoteConfig: removeConfig,
          databaseWriter: db
        )

        Device.showController(vc)
        RunLoop.main.run(until: Date().addingTimeInterval(1.0))

//        expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true, tolerance: 0.95))
      }
    }
  }
}
