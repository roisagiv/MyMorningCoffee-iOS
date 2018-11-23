//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation
@testable import MyMorningCoffee

class StubFormatter: MyMorningCoffee.Formatter {
  func relativeFromNow(date _: Date) -> String {
    return "22 minutes ago"
  }
}
