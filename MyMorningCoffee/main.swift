//
//  main.swift
//  MyMorningCoffee
//
//  Created by Roi Sagiv on 19/08/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
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
