//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
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
