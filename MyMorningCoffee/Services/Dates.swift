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

  class func iso8601(from date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    return formatter.string(from: date)
  }

  class func rfc3339(from date: Date) -> String {
    let formatter = Dates.iso8601Full
    return formatter.string(from: date)
  }

  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
