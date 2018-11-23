//
// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import UIKit

private func delegateClassName() -> String? {
  return NSClassFromString("XCTestCase") == nil ?
    NSStringFromClass(AppDelegate.self) :
    NSStringFromClass(TestAppDelegate.self)
}

private let unsafeArgv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
  .bindMemory(
    to: UnsafeMutablePointer<Int8>.self,
    capacity: Int(CommandLine.argc)
  )

_ = UIApplicationMain(CommandLine.argc, unsafeArgv, nil, delegateClassName())
