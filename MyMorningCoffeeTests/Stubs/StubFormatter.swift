//
//  StubFormatter.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 14/11/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation
@testable import MyMorningCoffee

class StubFormatter: MyMorningCoffee.Formatter {
  func relativeFromNow(date _: Date) -> String {
    return "22 minutes ago"
  }
}
