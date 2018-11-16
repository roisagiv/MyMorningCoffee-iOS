//
//  DateFormatter.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 14/11/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftMoment

protocol Formatter {
  func relativeFromNow(date: Date) -> String
}

class DefaultFormatter: Formatter {
  func relativeFromNow(date: Date) -> String {
    let momentDate = moment(date)
    return momentDate.fromNow()
  }
}

class SwiftDateFormatter: Formatter {
  func relativeFromNow(date: Date) -> String {
    return date.toRelative(style: RelativeFormatter.twitterStyle())
  }
}
