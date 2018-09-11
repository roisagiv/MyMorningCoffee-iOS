//
//  Device.swift
//  MyMorningCoffeeTests
//
//  Created by Roi Sagiv on 11/09/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

enum Device {
  case iPhoneSE
  case iPhone8
  case iPhone8Plus
  case iPhoneX

  var size: CGSize {
    switch self {
    case .iPhoneSE: return CGSize(width: 320, height: 568)
    case .iPhone8: return CGSize(width: 375, height: 667)
    case .iPhone8Plus: return CGSize(width: 414, height: 736)
    case .iPhoneX: return CGSize(width: 375, height: 812)
    }
  }

  var name: String {
    switch self {
    case .iPhoneSE: return "iPhoneSE"
    case .iPhone8: return "iPhone8"
    case .iPhone8Plus: return "iPhone8Plus"
    case .iPhoneX: return "iPhoneX"
    }
  }

  static let sizes: [String: CGSize] = [
    Device.iPhoneSE.name: Device.iPhoneSE.size,
    Device.iPhone8.name: Device.iPhone8.size,
    Device.iPhone8Plus.name: Device.iPhone8Plus.size,
    Device.iPhoneX.name: Device.iPhoneX.size
  ]
}
