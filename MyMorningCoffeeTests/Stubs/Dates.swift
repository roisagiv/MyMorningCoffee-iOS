//
//  Dates.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 15/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation

class Dates {
  class func dateFromISO8601(iso8601: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: iso8601)
  }
}
