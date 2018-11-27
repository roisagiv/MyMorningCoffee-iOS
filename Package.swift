// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// My Morning Coffee
//
// Copyright © 2018 Roi Sagiv. All rights reserved.
// This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
//

import PackageDescription

let package = Package(
  name: "MyMorningCoffee",
  dependencies: [
    .package(url: "https://github.com/orta/Komondor.git", from: "1.0.1"),
  ],
  targets: [
    // This is just an arbitrary Swift file in the app, that has
    // no dependencies outside of Foundation
    .target(name: "MyMorningCoffee", dependencies: [], path: "MyMorningCoffee", sources: ["main.swift"]),
  ]
)

#if canImport(PackageConfig)
  import PackageConfig

  let config = PackageConfig([
    "komondor": [
      "pre-commit": [
        "./Pods/SwiftFormat/CommandLineTool/swiftformat MyMorningCoffee --config .swiftformat",
        "./Pods/SwiftFormat/CommandLineTool/swiftformat MyMorningCoffeeTests --config .swiftformat",
        "./Pods/SwiftLint/swiftlint autocorrect",
        "./Pods/SwiftLint/swiftlint lint",
        "git add .",
      ],
    ],
  ])
#endif
