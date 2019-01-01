//
// My Morning Coffee
//
// Copyright © 2019 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import Foundation

class Dates {
  class func dateFromISO8601(iso8601: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: iso8601)
  }
}
