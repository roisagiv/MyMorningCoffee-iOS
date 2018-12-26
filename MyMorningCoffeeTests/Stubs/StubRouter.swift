//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

@testable import MyMorningCoffee
import UIKit

class StubRouter: Router {
  var nextRoute: Router.Route?

  override func root(route: Router.Route) {
    nextRoute = route
    // nothing
  }

  override func navigate(to route: Router.Route,
                         from _: UINavigationController?) {
    nextRoute = route
    // nothing
  }
}
